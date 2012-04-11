# Derringer

The mobile companion to [Booth](https://github.com/smashcon/booth), SMASH!'s online ticket sales system.

## Development

1. Install `node`, `npm` and `ruby` (1.9.2+).
2. Install both the required Javascript and Ruby packages:

```
gem install bundler
bundle install
sudo npm install -g coffee-script
sudo npm install -g batman
```

This will now work out of the box; to make changes, run the following in a terminal in the background somewhere:

```
# This will not produce any output. It just silently looks
# for any scss/*.scss or coffee/*.coffee changes, and compiles
# them to their CSS or JS output files respectively.

be rake watch
```

Now change something in `scss` or `coffee` and watch the spooky magic happen.
