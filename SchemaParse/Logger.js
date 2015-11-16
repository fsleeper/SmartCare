
function Logger() {

    this.Log = function (status) {
        this.Log2(status.file, status.numJSONRows, status.numGoodJSON, status.numBadJSON, status.goodSongPal, status.goodSBS, status.isTest, status.isSecurityCheck);

        var msg = "      ";
        for (var key in status.dynamicCounts) {
            msg = msg + key + ":" + status.dynamicCounts[key] + " ";
        }

        console.log(msg);
    }

    this.Log2 = function(file, numJSONRows, numGoodJSON, numBadJSON, goodSongPal, goodSBS,  isTest, isSecurityCheck) {
        console.log("File: " + file + ", Num JSON: " + numJSONRows + ", Good JSON: " + numGoodJSON + ", Bad JSON: " + numBadJSON + ", Tests: " + isTest + ", Security Check: " + isSecurityCheck + ", Good SongPal: " + goodSongPal + ", Good SBS: " + goodSBS);
    }
}

module.exports = Logger;