var privateVar = 100;

/**
 * @param {string|number}
 */
function logValue(value) {
    console.log(value);
}

/**
 * @constructor
 */
function SomeObject() {
    this.prop1 = "default";
    this.prop2 = 10;
}

SomeObject.WRAPPER_START = "[";
SomeObject.WRAPPER_END = "]";

/**
 * @return {string}
 */
SomeObject.prototype.getDescription = function () {
    var result = this.prop1 + " - " + this.prop2;
    logValue(result);
    return result;
};

/**
 * @param {string} value
 * @return {string}
 */
SomeObject.prototype.wrap = function (value) {
    return SomeObject.WRAPPER_START + value + SomeObject.WRAPPER_END;
};

module.exports = SomeObject;
