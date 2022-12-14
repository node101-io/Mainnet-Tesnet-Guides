## Here's a quick guide for Celestia Network **mamaki** testnet.  Please feel free to use our guide and do not hasistate to reach us out for any needs. 

``` 
wget -O mocha.sh https://node101.io/celestia/testnet/mocha.sh && chmod +x mocha.sh && ./mocha.sh 
 
```
Create a validator

```
celestia-appd tx staking create-validator \
--amount=1000000utia \
--pubkey=$(celestia-appd tendermint show-validator) \
--moniker=<nodename> \
--chain-id=mocha \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1000000 \
--from=<yourwalletaddress> \
--keyring-backend=test \
--evm-address=$EVM \
--orchestrator-address=$ORCHESTRATOR_ADDRES \
--fees 1000utia \
--gas-adjustment=1.4 \
--gas=6000 \
-y
```

#### Don't forget to support us and our contents by subscribing to our channel!
#### ð¦ Follow us on Twitter âº https://twitter.com/node_101
#### ð Join our Telegram channel! âº https://t.me/node101
#### ð Get detailed information about us by visiting our website! âº https://www.node101.io
#### ð¼ Contact us on LinkedIn! âºhttps://www.linkedin.com/company/node101/
#### ð You can find our links here âº https://linktr.ee/node101