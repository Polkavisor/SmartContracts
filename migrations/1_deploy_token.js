// migrations/1_deploy_token.js
const Token = artifacts.require("PolkavisorToken");

module.exports = async function (deployer) {
  await deployer.deploy(Token);
};
