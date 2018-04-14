/**
 * CloudHero Cloud Function Challenge!
 */
const request = require('request');

const HUB_ENDPOINT_URL = 'https://us-central1-cloudhero-e07c6.cloudfunctions.net/cloudFunctionChallenge_verifyCallback';

/**
 * Cloud Function to be triggered by Pub/Sub and will post payload received
 * to an identified endpoint in the CloudHero hub
 *
 * @param {object} event The Cloud Functions event.
 * @param {function} callback The callback function.
 */
exports.pubSubListener = (event, callback) => {
  const message = event.data;
  const payload = (message && message.data) ? Buffer.from( message.data, 'base64').toString() : null;

  const options = {
    json: JSON.parse(payload)
  };

  request.post(HUB_ENDPOINT_URL, options, callback);
};