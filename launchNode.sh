cd node$1
echo "cd to node$1"
pwd
nohup  geth  --identity "test_priv_net_node$1" --rpc --rpcaddr="0.0.0.0" --rpcport "800$1" --rpccorsdomain "*"   --networkid 12340  --datadir $testnet_root/node$1/.ethereum_private --port "3030$1"  --rpcapi "db,eth,net,web3" --ipcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3"  --ipcpath "$testnet_root/node$1/geth.ipc" --nodiscover  &
tail -f nohup.out
