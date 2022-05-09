Reset = "\x1b[0m"
Bright = "\x1b[1m"
Dim = "\x1b[2m"
Underscore = "\x1b[4m"
Blink = "\x1b[5m"
Reverse = "\x1b[7m"
Hidden = "\x1b[8m"
FgBlack = "\x1b[30m"
FgRed = "\x1b[31m"
FgGreen = "\x1b[32m"
FgYellow = "\x1b[33m"
FgBlue = "\x1b[34m"
FgMagenta = "\x1b[35m"
FgCyan = "\x1b[36m"
FgWhite = "\x1b[37m"
BgBlack = "\x1b[40m"
BgRed = "\x1b[41m"
BgGreen = "\x1b[42m"
BgYellow = "\x1b[43m"
BgBlue = "\x1b[44m"
BgMagenta = "\x1b[45m"
BgCyan = "\x1b[46m"
BgWhite = "\x1b[47m"

var exec = require('child_process').exec;

function isANumber(str) {
    return /^-?\d+\.?\d*$|^\d*\.?\d+$/.test(str);
}

function ErrorsFounds(str) {
    console.log(FgRed, str)
    process.exit(84)
}

function testImageCompresor() {

    if (process.argv.length != 5)
        ErrorsFounds("Usage: node Testeur.js <Cluster_Nb> <Convergence_Nb> <image_path>");

    var ClusterNb = isANumber(process.argv[2]) ? process.argv[2] : ErrorsFounds("ClusterNb is not a number")
    var Convergence = isANumber(process.argv[3]) ? process.argv[3] : ErrorsFounds("Convergence is not a number")
    var FilePath = process.argv[4] ? process.argv[4] : ErrorsFounds("FilePath is not a string")

    console.log(Bright, FgCyan, "\n<-- ImageCompressor Tester -->\n", Reset);
    console.log(FgYellow, "\n<-- Launching imageCompressorHelper to generate pixel file...", Reset);
    exec('cd ./imageCompressorHelper; stack exec ich ../' + FilePath + ' > ../ImgToTxt.txt ; cd -',
        function (error, stdout, stderr) {
        var newTxt = 'ImgToTxt.txt'
        if (error !== null) {
            ErrorsFounds('error in ImageCompressorHelper' + error);
        } else {
            console.log(FgGreen, "\n- ImageCompressorHelper finished successfuly !", Reset);
            console.log(FgYellow, "\n<-- Executing ImageCompresor with given parameters... -->", Reset);
        }
        exec('cd ../; time ./imageCompressor -n ' + ClusterNb + ' -l ' + Convergence + ' -f ' + './tests/' + newTxt + ' > newCompressedImage; mv newCompressedImage ./tests/ ; cd -', 
            function (error, stdout, stderr) {
                console.log(stdout, stderr)
                if (error !== null) {
                    ErrorsFounds('exec error in imageCompressor: ' + error);
                } else {
                    console.log(FgGreen, "\n- Imagecompressor finished successfuly !");
                    console.log(FgYellow, "\n <-- Creating Clone of my image.. -->");
                }
                exec('cp ' + FilePath + ' newGenerated_Img.png',
                    function (error, stdout, stderr) {
                        if (error !== null) {
                            ErrorsFounds('exec error: ' + error);
                        } else {
                            console.log(FgGreen, "\n- Clone finished successfuly !");
                            console.log(FgYellow, "\n<-- Executing ImageCompresorHelper to generate my new image... -->", Reset);
                        }
                        exec('cd ./imageCompressorHelper; stack exec ich ../' + FilePath + ' ' + '../newCompressedImage' + ' ../newGenerated_Img.png; cd -',
                            function (error, stdout, stderr) {
                                if (error !== null) {
                                    ErrorsFounds('exec error: ' + error);
                                } else {
                                    console.log(FgGreen, "\n- New image created successfully (newGenerated_Img.png)");
                                }
                        });
                });
            });
    });
}

testImageCompresor()