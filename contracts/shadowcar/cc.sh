#!/bin/bash

export FABRIC_CFG_PATH=/home/bstudent/fabric-samples/config

#1 package
peer lifecycle chaincode package shadowcar.tar.gz --path /home/bstudent/dev/contracts/shadowcar/ --lang golang --label shadowcar_1_1 # shadowcar_1.1

#2 install
# org1 연결설정 ( ADDRESS, MSPID, MSPCONFIGPATH, TLS정보)
export TESTPATH=/home/bstudent/fabric-samples/test-network
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=${TESTPATH}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${TESTPATH}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

peer lifecycle chaincode install shadowcar.tar.gz

# org2 연결설정 ( ADDRESS, MSPID, MSPCONFIGPATH, TLS정보)
export CORE_PEER_TLS_ROOTCERT_FILE=${TESTPATH}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_MSPCONFIGPATH=${TESTPATH}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode install shadowcar.tar.gz

#3 approve
# org1 conncet
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls  --cafile /home/bstudent/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mychannel --name shadowcar --version 1.1 --package-id shadowcar_1_1:2730d1248ef062cb25e96f48f25a7efae67edc550a93c96a554f8fcd67d4cbaf --sequence 2

# org2 conncet
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile /home/bstudent/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mychannel --name shadowcar --version 1 --package-id shadowcar_1:489c903577f3ea60f336404873b3d0ebe8f6f4d1e282e431aa5d9e5bcd33f33e --sequence 1

#4 commit
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile /home/bstudent/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mychannel --name shadowcar --peerAddresses localhost:7051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --version 1.1 --sequence 2

# install query
peer lifecycle chaincode queryinstalled

# approve checkcommitreadiness
peer lifecycle chaincode querycommitted -C mychannel
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name shadowcar --version 1 --seqeunce 1 --output json

# query QueryAllCars
peer chaincode query -n shadowcar -C mychannel -c '{"Args":["QueryAllCars"]}'

# invoke createCar CAR10 BMW 420d white bstudent
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile /home/bstudent/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mychannel --name shadowcar --peerAddresses localhost:7051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["InitLedger"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile /home/bstudent/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mychannel --name shadowcar --peerAddresses localhost:7051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["CreateCar", "CAR10", "BMW", "420d", "White", "bstudent"]}'

# query QueryCar CAR10
peer chaincode query -n shadowcar -C mychannel -c '{"Args":["QueryCar","CAR10"]}'

# invoke ChangeCarOwner CAR10 -> blockchain
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile /home/bstudent/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mychannel --name shadowcar --peerAddresses localhost:7051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles /home/bstudent/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["ChangeCarOwner", "CAR10", "blockchain"]}'

# query GetHistory CAR10
peer chaincode query -n shadowcar -C mychannel -c '{"Args":["GetHistory","CAR10"]}'