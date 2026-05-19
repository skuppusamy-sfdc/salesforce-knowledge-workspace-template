import { LightningElement, api } from 'lwc';
import getJobStatus from '@salesforce/apex/JobStatusController.getJobStatus';

const POLL_INTERVAL_MS = 5000;
const MAX_POLL_MS = 120000; // 2 minutes

export default class JobMonitor extends LightningElement {
    _value;
    jobType = '';
    jobId = '';
    batchProcessId = '';
    jobLabel = 'Processing...';
    status = '';
    message = '';
    processedCount = 0;
    totalCount = 1;
    progressPercent = 0;
    isComplete = false;
    isFailed = false;
    isTimedOut = false;
    pollStartTime = 0;
    pollTimer = null;

    @api
    get value() {
        return this._value;
    }
    set value(newValue) {
        this._value = newValue;
        if (newValue) {
            this.initFromValue(newValue);
        }
    }

    initFromValue(val) {
        const job = val.asyncJob || val;
        this.jobType = job.jobType || '';
        this.jobId = job.jobId || '';
        this.batchProcessId = job.batchProcessId || '';
        this.jobLabel = job.jobLabel || 'Processing...';
        this.status = 'Queued';
        this.message = job.message || 'Starting...';
        this.processedCount = 0;
        this.totalCount = 1;
        this.progressPercent = 0;
        this.isComplete = false;
        this.isFailed = false;
        this.isTimedOut = false;
        this.pollStartTime = Date.now();

        if (this.jobId || this.batchProcessId) {
            this.startPolling();
        }
    }

    startPolling() {
        this.poll();
        this.pollTimer = setInterval(() => {
            if (Date.now() - this.pollStartTime >= MAX_POLL_MS) {
                this.stopPolling();
                this.isTimedOut = true;
                this.message = 'This is taking longer than expected. You will receive a notification when it completes. Please check back then.';
                return;
            }
            this.poll();
        }, POLL_INTERVAL_MS);
    }

    stopPolling() {
        if (this.pollTimer) {
            clearInterval(this.pollTimer);
            this.pollTimer = null;
        }
    }

    async poll() {
        if (!this.jobId && !this.batchProcessId) return;
        try {
            const result = await getJobStatus({
                jobType: this.jobType,
                jobId: this.jobId,
                batchProcessId: this.batchProcessId,
            });
            this.status = result.status || this.status;
            this.message = result.message || this.message;
            this.processedCount = result.processedCount || 0;
            this.totalCount = result.totalCount || 1;
            this.progressPercent = this.totalCount > 0 ? Math.min(100, Math.round((this.processedCount / this.totalCount) * 100)) : 0;
            this.isComplete = result.isComplete || false;
            this.isFailed = this.isComplete && (result.status === 'Failed' || result.status === 'Aborted' || result.status === 'Error');

            if (this.isComplete) {
                this.stopPolling();
            }
        } catch (error) {
            this.message = 'Unable to check status. You will be notified when complete.';
        }
    }

    disconnectedCallback() {
        this.stopPolling();
    }

    get showProgressBar() {
        return !this.isComplete && !this.isTimedOut && this.totalCount > 0;
    }

    get statusIcon() {
        if (this.isComplete && this.isFailed) return 'utility:error';
        if (this.isComplete) return 'utility:success';
        if (this.isTimedOut) return 'utility:info';
        return 'utility:refresh';
    }

    get showProgressRing() {
        return !this.isComplete && !this.isTimedOut;
    }

    get iconVariant() {
        if (this.isComplete && this.isFailed) return 'error';
        if (this.isComplete) return 'success';
        return 'inverse';
    }
}