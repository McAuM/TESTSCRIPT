#!/bin/bash

sh /home/hadoop/TESAPI/TESTSCRIPT/Box/refreshboxapi1
sh /home/hadoop/TESAPI/TESTSCRIPT//Box/refreshboxapi2
sh /home/hadoop/TESAPI/TESTSCRIPT//GoogleDrive/refreshgoogledriveapi

rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.box1
rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.box2
rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.gdrive1
rm -rf /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box1
rm -rf /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box2

cp /home/hadoop/TESAPI/TESTSCRIPT/Box/token.box1 /home/hadoop/TESAPI/TESTSCRIPT/token.box1
cp /home/hadoop/TESAPI/TESTSCRIPT/Box/token.box2 /home/hadoop/TESAPI/TESTSCRIPT/token.box2
cp /home/hadoop/TESAPI/TESTSCRIPT/Box/refreshtoken.box1 /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box1
cp /home/hadoop/TESAPI/TESTSCRIPT/Box/refreshtoken.box2 /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box2
cp /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/token.gdrive1 /home/hadoop/TESAPI/TESTSCRIPT/token.gdrive1
