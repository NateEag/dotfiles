/**
 * @param {number} code
 * @param {string} message
 * @constructor
 */
function SimpleError (code, message) {
    this.code = code;
    this.message = message;
}

module.exports = SimpleError;
