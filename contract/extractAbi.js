const fs = require('fs');
const sync = require('synchronize');
const path = require('path');
sync(fs, 'readFile', 'readdir');
const folderPath = './build/contracts/';


sync.fiber(function() {
    let interfaceObj;
    let abiObj;
    let fileName;
    let files = fs.readdir(folderPath);
    let writeBasePath = './abi/';
    let admin = 'admin';
    let getter = 'getter';
    let submitter= 'submitter';
    let miner = 'miner';
    let other = 'other';
    let writePath;

    createDir(writeBasePath);
    createDir(writeBasePath+admin);
    createDir(writeBasePath+getter);
    createDir(writeBasePath+submitter);
    createDir(writeBasePath+miner);
    createDir(writeBasePath+other);


    console.log(path.delimiter);
    for (let i in files) {
        fileName = files[i];
        if (fileName.toLowerCase().includes('interface')) {
            writePath = writeBasePath;
            file = fs.readFile(folderPath + fileName, 'utf-8');
            interfaceObj = JSON.parse(file);
            abiObj = {abi:interfaceObj.abi};
            if (fileName.toLowerCase().includes(admin)){
                writePath = writePath+admin+'/'+fileName;
            }
            else if (fileName.toLowerCase().includes(getter)){
                writePath = writePath+getter+'/'+fileName;
            }
            else if (fileName.toLowerCase().includes(miner)){
                writePath = writePath+miner+'/'+fileName;
            }
            else if (fileName.toLowerCase().includes(submitter)){
                writePath = writePath+submitter+'/'+fileName;
            }
            else writePath = writePath+other+'/'+fileName;
            fs.writeFile(writePath, JSON.stringify(abiObj,null,4));
        }
    }
});

function createDir(path) {
    if (!fs.existsSync(path)) {
        fs.mkdirSync(path);
    }
}



