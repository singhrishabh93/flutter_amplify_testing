import { defineBackend } from "@aws-amplify/backend"
import { auth } from "./auth/resource"

const backend = defineBackend({
  auth,
})

const { cfnResources } = backend.auth.resources;
const { cfnUserPool, cfnUserPoolClient } = cfnResources;

cfnUserPool.addPropertyOverride(
	'Policies.SignInPolicy.AllowedFirstAuthFactors',
	['SMS_OTP']
);

cfnUserPoolClient.explicitAuthFlows = [
	'ALLOW_REFRESH_TOKEN_AUTH',
	'ALLOW_USER_AUTH'
];

/* Needed for WebAuthn */
cfnUserPool.addPropertyOverride('WebAuthnRelyingPartyID', '<RELYING_PARTY>');
cfnUserPool.addPropertyOverride('WebAuthnUserVerification', 'preferred');