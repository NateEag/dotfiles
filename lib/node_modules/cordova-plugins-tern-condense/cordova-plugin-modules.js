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
/*global exports, module, require, define, tern */

(function (mod) {
    if (typeof exports === "object" && typeof module === "object") { // CommonJS
        return mod(require("../tern/lib/infer"), require("../tern/lib/tern"), require("../tern/plugin/modules"), require);
    }
    if (typeof define === "function" && define.amd) { // AMD
        return define(["../tern/lib/infer", "../tern/lib/tern", "../tern/plugin/modules"]);
    }
    mod(tern, tern);
})(function (infer, tern) {
    "use strict";

    function preCondenseReach(state) {
        if (!state.roots["!modules"]) {
            return;
        }

        // patchModules
        var server = infer.cx().parent,
            modModules = server.mod.modules.modules,
            mods = server.mod.cordovaPluginDef.modulesDef,
            node = state.roots["!modules"], // infer.Obj
            props = node.props,
            currProp,
            modDef,
            mod,
            prop,
            path;

        for (path in props) {
            currProp = props[path];
            modDef = mods[currProp.origin];
            mod = modModules[currProp.origin];

            if (modDef) {
                prop = node.defProp(modDef.name);
                mod.origin = modDef.name;
                mod.propagate(prop);
                prop.origin = mod.origin;
            }

            delete props[path];
        }
    }

    function postCondense(state) {
        if (!state.output["!define"] || !state.output["!define"]["!modules"]) {
            return;
        }

        var output = state.output,
            modulesOutput = state.output["!define"]["!modules"],
            cordovaPluginDef = infer.cx().parent.mod.cordovaPluginDef,
            name,
            moduleDef,
            outputPoint,
            namespace;

        for (name in modulesOutput) {
            moduleDef = cordovaPluginDef.getModuleDefByName(name);

            if (moduleDef) {
                outputPoint = "!modules." + name;
                namespace = moduleDef.getNamespace();

                var count = namespace.length,
                    lastIndex = count - 1,
                    lastNamespace = output,
                    part,
                    i;

                for (i = 0; i < count; i++) {
                    part = namespace[i];

                    if (!lastNamespace[part]) {
                        lastNamespace[part] = (i === lastIndex) ? outputPoint : {};
                    }

                    lastNamespace = lastNamespace[part];
                }
            }
        }
    }

    tern.registerPlugin("cordova-plugin-modules", function (server, options) {
        server.loadPlugin("modules");

        server.on("preCondenseReach", preCondenseReach);
        server.on("postCondense", postCondense);
    });
});
