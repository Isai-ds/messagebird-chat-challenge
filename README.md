# Message Bird Chatter

Chat solution using MessageBird APIs and MessageBird Whatsapp Sandbox. To test the solution you need to have an MessageBird account. If you don't have, you can create a new one using next [link](https://dashboard.messagebird.com/sign-up/).
Once logged in your Message bird account, the next step is activate your whatsapp account. Please follow the next instruccions [Whatsapp Sandbox](https://support.messagebird.com/hc/en-us/articles/360002109957-Start-testing-with-the-MessageBird-WhatsApp-Sandbox).

## Installing the App using a Developer Edition Org

Follow this set of instrucctios to install the unamed package in a [free Developer Edition Org](https://developer.salesforce.com/signup). We remommend start from a Brand-new environment to avoid conflicts with any previous work. To execute next commands you need to have sfdx-cli package installed.

1. Clone the repo
```
 git clone https://github.com/Isai-ds/messagebird-chat-challenge.git
```
2. Authorize your Developer org and provide it with alias, for example myorg

```
 sfdx auth:web:login -s -a mydevorg
```

3. Run this command to deploy the app

```
sfdx force:source:deploy --testlevel RunLocalTests --wait 10 -u myorg
```

4. Assign the MessageBirdAdmin permission set to the default user

```
sfdx force:user:permset:assign -n MessageBirdAdmin -u myorg
```

5. If your org isn’t already open, opent it now

```
sfdx force:org:open -u mydevorg
```

6. In App Launche, select the Message Bird Admin App to continue with next configuration.

## Read All About It

- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
