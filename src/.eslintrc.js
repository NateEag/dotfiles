// Nate Eagleson's ESLint config.
//
// In some sense it's a mistake to have this, since it should be specified
// per-project, but sometimes I do edit in projects that don't specify one.
//
// In those cases, having a basic standard that Emacs automatically falls back
// to helps keep me honest.
module.exports = {
    "extends": "standard",
    "plugins": [
        "standard",
        "promise"
    ],
    "rules": {
        "semi": ["error", "always"],
        "indent": ["error", 4]
    }
};
