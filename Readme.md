###Dependencies

* jQuery >1.9 (actually don't know if lower works, but hey this is what we used)

####Test
* [node](https://github.com/joyent/node) - tested with 0.10.8
* [grunt-cli](http://gruntjs.com/getting-started) - installed through npm
* [phantom.js](http://phantomjs.org/) - can be install with brew, pacman, apt-get, whatever you use.

####Run Tests

```bash
npm install # install package.json
grunt test  # compiles coffeescript and runs jasmine tests.
```