/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Intel Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*jslint vars: true, plusplus: true, devel: true, nomen: true, indent: 4,
maxerr: 50 */
/*global require, describe, beforeEach, it, process */

var expect = require("chai").expect,
    execFile = require("child_process").execFile;

describe("Tern condense cordova plugins", function () {
    "use strict";

    var args;

    beforeEach(function () {
        args = ["../tern/bin/condense", "--plugin", "cordova-plugins-condense.js"];
    });

    it("should generate definitions for a single namespace definition, at default (window)", function (done) {
        args.push("tests/data/simple1/plugin.xml");

        execFile(process.execPath, args, function (err, stdout, stderr) {

            if (stderr) {
                throw stderr;
            }

            var ternDef = JSON.parse(stdout);

            expect(ternDef).to.exist;
            expect(ternDef["!name"]).to.equal("test-plugin-1");
            expect(ternDef["!plugin-version"]).to.equal("0.0.1");
            expect(ternDef["!define"]).to.be.an("object");
            expect(ternDef.Simple).to.equal("!modules.Simple");
            expect(Object.keys(ternDef).length).to.equal(4);

            done();
        });
    });

    it("should generate definitions for a single namespace definition in navigator", function (done) {
        args.push("tests/data/simple2/plugin.xml");

        execFile(process.execPath, args, function (err, stdout, stderr) {
            if (stderr) {
                throw stderr;
            }

            var ternDef = JSON.parse(stdout);

            expect(ternDef).to.exist;
            expect(ternDef["!name"]).to.equal("test-plugin-2");
            expect(ternDef["!plugin-version"]).to.equal("0.0.1");
            expect(ternDef["!define"]).to.be.an("object");
            expect(ternDef.navigator).to.be.an("object");
            expect(ternDef.navigator.simplemodule).to.equal("!modules.Simple");
            expect(Object.keys(ternDef).length).to.equal(4);

            done();
        });
    });

    it("should generate definitions for more than one modules", function (done) {
        args.push("tests/data/plugin3/plugin.xml");

        execFile(process.execPath, args, function (err, stdout, stderr) {
            if (stderr) {
                throw stderr;
            }

            var ternDef = JSON.parse(stdout);

            expect(ternDef).to.exist;
            expect(ternDef["!name"]).to.equal("test-plugin-3");
            expect(ternDef["!plugin-version"]).to.equal("0.0.1");
            expect(ternDef["!define"]).to.be.an("object");
            expect(ternDef.cordovaplugincondense).to.be.an("object");
            expect(ternDef.cordovaplugincondense.simplemodule).to.equal("!modules.Simple");
            expect(ternDef.navigator).to.be.an("object");
            expect(ternDef.navigator.dummy).to.be.equal("!modules.SimpleError");
            expect(ternDef.OtherModule).to.be.equal("!modules.OtherModule");
            expect(Object.keys(ternDef).length).to.equal(6);

            done();
        });
    });

    it("should generate definitions for more than one modules and complex namespaces", function (done) {
        args.push("tests/data/plugin4/plugin.xml");

        execFile(process.execPath, args, function (err, stdout, stderr) {
            if (stderr) {
                throw stderr;
            }

            var ternDef = JSON.parse(stdout);

            expect(ternDef).to.exist;
            expect(ternDef["!name"]).to.equal("test-plugin-4");
            expect(ternDef["!plugin-version"]).to.equal("0.0.1");
            expect(ternDef["!define"]).to.be.an("object");
            expect(ternDef.cordovaplugincondense).to.be.an("object");
            expect(ternDef.cordovaplugincondense.simplemodule).to.equal("!modules.Simple");
            expect(ternDef.navigator.pluginerror).to.be.an("object");
            expect(ternDef.navigator.pluginerror.SimpleError).to.be.equal("!modules.SimpleError");
            expect(ternDef.navigator.dummy).to.be.an("object");
            expect(ternDef.navigator.dummy.jam).to.be.equal("!modules.JustAnotherModule");
            expect(ternDef.navigator.dummy.magic).to.be.equal("!modules.Magic");
            expect(ternDef.OtherModule).to.be.equal("!modules.OtherModule");
            expect(Object.keys(ternDef).length).to.equal(6);

            done();
        });
    });
});
