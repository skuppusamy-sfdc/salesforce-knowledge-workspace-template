import { LightningElement, track } from 'lwc';
import findUserByEmail from '@salesforce/apex/CommunityLoginController.getUserByEmail';
import authenticateUser from '@salesforce/apex/CommunityLoginController.login';
import isUserLocked from '@salesforce/apex/CommunityLoginController.isUserLocked';
import OKTA_SSO_URL from '@salesforce/label/c.OktaSSOUrl';

export default class ScpLogin extends LightningElement {
    LOCKED_ACCOUNT_MESSAGE = 'Your account has been locked due to too many failed login attempts. Please contact your recruiter for assistance.';
    @track email = '';
    @track password = '';
    @track showPassword = false;
    @track errorMessage = '';
    @track buttonLabel = 'Next';

    handleEmailChange(event) {
		this.showPassword = false;
		this.buttonLabel = 'Next';
		this.errorMessage = '';
        this.email = event.target.value;
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
    }

    async handleLogin() {
        this.errorMessage = '';
        if (!this.email) {
            this.errorMessage = 'Please enter an email address.';
            return;
        }

        try {
            if (!this.showPassword) {
                // Step 1: Query User by Email
                const user = await findUserByEmail({ email: this.email });

                if (!user  || !user.Username) {
                    this.errorMessage = 'User not found';
                    return;
                }

				this.username = user.Username;

                if (user.FederationIdentifier) {
                    // Redirect to Okta SSO
                    window.location.href = OKTA_SSO_URL;
                } else {
                    // Show password input for direct login
                    this.showPassword = true;
                    this.buttonLabel = 'Log In';
                }
            } else {
                // Step 2: Perform authentication via Apex
                const locked = await isUserLocked({ email: this.email });
                if (locked) {
                    this.errorMessage = this.LOCKED_ACCOUNT_MESSAGE;
                    return;
                }

                const loginRedirectUrl = await authenticateUser({
					username: this.username,
					password: this.password
				});

                if (loginRedirectUrl) {
					// Redirect to page returned by Site.login()
					window.location.href = loginRedirectUrl;
				} else {
					this.errorMessage = 'Invalid credentials.';
				}
            }
        } catch (error) {
            this.errorMessage = error.body?.message || 'Unexpected error occurred.';
        }
    }

	handleForgotPassword() {
		const baseUrl = window.location.origin;
		const currentPath = window.location.pathname;

		// Check if community URL already includes "/s/"
		let redirectPath = '/s/ForgotPassword';
		if (!currentPath.includes('/s/')) {
			redirectPath = '/ForgotPassword';
		}

		// Redirect to correct Forgot Password page
		window.location.href = `${baseUrl}${redirectPath}`;
	}
}