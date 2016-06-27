# xa-006

A demo made using WebGL.

This is a project based on <https://github.com/joakimk/livecoding_workspace>.

# TODO

- replace the example music

# Development

## Installing

Before you start, ensure you have Node and Elixir installed. I'm using Elixir 1.3.0 and Node v5.5.0, but other versions will likely work as well.

    mix deps.get
    npm install

## Editing code

Start the server

    mix phoenix.server

0. Visit <http://localhost:4000>
  0. If you get a "no process" error in the console, reload the page once.
0. Then edit [web/static/js/demo.coffee](web/static/js/demo.coffee) and see the changes appear in the browser right away.

## Editing the flow and music sync

0. Get "GNU rocket" with websocket support (needs QT5)
0. Go to <http://localhost:4000/?tracker=true>
0. The tracks will appear in the editor.
0. Load the existing data file from web/static/assets/demo.rocket.
0. Press space and the demo will run.
0. Edit
0. Save
0. Commit the changes made to demo.rocket.

## Exporting the final result to xa-006.html

    mix release

## License

Copyright (c) 2016 [Joakim Kolsjö](https://twitter.com/joakimk)

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
