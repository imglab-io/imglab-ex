# imglab

`imglab` is the official Elixir library to integrate with imglab services.

## Installation

Add `imglab` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:imglab, "~> 0.3"}
  ]
end
```

And run:

```sh
mix deps.get
```

## Elixir compatibility

`imglab` has been successfully tested on the following Elixir versions: `1.14`, `1.13`, `1.12`, `1.11`, `1.10`, `1.9`, `1.8`, `1.7`, `1.6`, `1.5`, and `1.4`.

## Generating URLs

You can use `Imglab.url/3` function to generate imglab compatible URLs for your application.

The easiest way to generate a URL is to specify the `source_name`, `path` and required `parameters`:

```elixir
Imglab.url("assets", "image.jpeg", width: 500, height: 600)
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600"

Imglab.url("avatars", "user-01.jpeg", width: 300, height: 300, mode: :crop, crop: :face, format: :webp)
"https://avatars.imglab-cdn.net/user-01.jpeg?width=300&height=300&mode=crop&crop=face&format=webp"
```

If some specific settings are required for the source you can use a `Imglab.Source` struct instead of a `string` source name:

```elixir
Imglab.url(Imglab.Source.new("assets"), "image.jpeg", width: 500, height: 600)
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600"
```

### Using secure image sources

For sources that require signed URLs you can specify `secure_key` and `secure_salt` attributes:

```elixir
"assets"
|> Imglab.Source.new(secure_key: "assets-secure-key", secure_salt: "assets-secure-salt")
|> Imglab.url("image.jpeg", width: 500, height: 600)
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&signature=generated-signature"
```

`signature` query parameter will be automatically generated and attached to the returned URL.

> Note: `secure_key` and `secure_salt` attributes are secrets that should not be added to a code repository. Please use environment vars or other secure method to use them in your application.

### Using HTTP instead of HTTPS

In the case that HTTP schema is required instead of HTTPS you can set `https` attribute to `false` when creating the source:

```elixir
"assets"
|> Imglab.Source.new(https: false)
|> Imglab.url("image.jpeg", width: 500, height: 600)
"http://assets.imglab-cdn.net/image.jpeg?width=500&height=600"
```

> Note: HTTPS is the default and recommended way to generate URLs with imglab.

### Specifying parameters

Any parameter from the imglab API can be used to generate URLs with `Imglab.url/3` function. For parameters that required dashes characters like `trim-color` you can use regular underscore Elixir atoms like `:trim_color` those will be normalized in the URL generation to it's correct form:

```elixir
Imglab.url("assets", "image.jpeg", trim: "color", trim_color: "black")
"https://assets.imglab-cdn.net/image.jpeg?trim=color&trim-color=black"
```

It is possible to use quoted atoms too:

```elixir
Imglab.url("assets", "image.jpeg", trim: "color", "trim-color": "black")
"https://assets.imglab-cdn.net/image.jpeg?trim=color&trim-color=black"
```

### Specifying color parameters

Some imglab parameters can receive a color as value. It is possible to specify these color values as strings:

```elixir
# Specifying a RGB color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "255,0,0")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0"

# Specifying a RGBA color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "255,0,0,128")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0%2C128"

# Specifying a named color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "red")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&mode=contain&background-color=red"

# Specifying a hexadecimal color as string
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: :contain, background_color: "F00")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&mode=contain&background-color=F00"
```

You can additionally use `Imglab.Color` macros to specify these color values:

```elixir
# Remember to import Imglab.Color before use these macros
import Imglab.Color

# Using color macro for a RGB color
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: "contain", background_color: color(255, 0, 0))
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0"

# Using color macro for a RGBA color
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: "contain", background_color: color(255, 0, 0, 128))
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&mode=contain&background-color=255%2C0%2C0%2C128"

# Using color macro for a named color
Imglab.url("assets", "image.jpeg", width: 500, height: 600, mode: "contain", background_color: color("red"))
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&mode=contain&background-color=red"
```

> Note: specify hexadecimal color values using `Imglab.Color` macros is not allowed. You can use strings instead.

### Specifying position parameters

Some imglab parameters can receive a position as value. It is possible to specify these values using strings:

```elixir
# Specifying a horizontal and vertical position as string
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: "left,top")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=500&mode=crop&crop=left%2Ctop"

# Specifying a vertical and horizontal position as string
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: "top,left")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=500&mode=crop&crop=top%2Cleft"

# Specifying a position as string
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: "left")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=500&mode=crop&crop=left"
```

You can additionally use `Imglab.Position` macros to specify these position values:

```elixir
# Remember to import Imglab.Position before use these macros
import Imglab.Position

# Using position macro for a horizontal and vertical position
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: position("left", "top"))
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=500&mode=crop&crop=left%2Ctop"

# Using position macro for a vertical and horizontal position
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: position("top", "left"))
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=500&mode=crop&crop=top%2Cleft"

# Using position macro for a position
Imglab.url("assets", "image.jpeg", width: 500, height: 500, mode: "crop", crop: position("left"))
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=500&mode=crop&crop=left"
```

### Specifying URL parameters

Some imglab parameters can receive URLs as values. It is possible to specify these parameter values as strings.

```elixir
Imglab.url("assets", "image.jpeg", width: 500, height: 600, watermark: "logo.svg")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&watermark=logo.svg"
```

And even use parameters if required:

```elixir
Imglab.url("assets", "image.jpeg", width: 500, height: 600, watermark: "logo.svg?width=100&format=png")
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&watermark=logo.svg%3Fwidth%3D100%26format%3Dpng"
```

Additionally you can use nested `Imglab.url/3` calls to specify these URL values:

```elixir
Imglab.url(
  "assets",
  "image.jpeg",
  width: 500,
  height: 600,
  watermark: Imglab.url("assets", "logo.svg", width: 100, format: :png)
)
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Flogo.svg%3Fwidth%3D100%26format%3Dpng"
```

If the resource is located in a different source we can specify it using `Imglab.url/3`:

```elixir
Imglab.url(
  "assets",
  "image.jpeg",
  width: 500,
  height: 600,
  watermark: Imglab.url("marketing", "logo.svg", width: 100, format: :png)
)
"https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&watermark=https%3A%2F%2Fmarketing.imglab-cdn.net%2Flogo.svg%3Fwidth%3D100%26format%3Dpng"
```

Using secure sources for URLs parameter values is possible too:

```elixir
marketing_source = Imglab.Source.new("marketing", secure_key: "marketing-secure-key", secure_salt: "marketing-secure-salt")

Imglab.url(
  "assets",
  "image.jpeg",
  width: 500,
  height: 600,
  watermark: Imglab.url(marketing_source, "logo.svg", width: 100, format: :png)
)
```

`signature` query parameter will be automatically generated and attached to the nested URL value.

### Specifying URLs with expiration timestamp

The `expires` parameter allows you to specify a UNIX timestamp in seconds after which the request is expired.

If an Elixir `DateTime` struct is used as value to `expires` parameter it will be automatically converted to UNIX timestamp. In the following example, we specify an expiration time of one hour, adding 3600 seconds to the current time:

```elixir
expires = DateTime.add(DateTime.utc_now(), 3600)

Imglab.url("assets", "image.jpeg", width: 500, expires: expires)
```

If you are using an older Elixir version without `DateTime.add/4` function you can add a number of seconds after transforming to UNIX timestamp:

```elixir
expires = DateTime.to_unix(DateTime.utc_now()) + 3600

Imglab.url("assets", "image.jpeg", width: 500, expires: expires)
```

> Note: The `expires` parameter should be used in conjunction with secure sources. Otherwise, `expires` value could be tampered with.

## Generating URLs for on-premises imglab server

For on-premises imglab server is possible to define custom sources pointing to your server location.

* `:https` - a `boolean` value specifying if the source should use https or not (default: `true`)
* `:host` - a `string` specifying the host where the imglab server is located. (default: `imglab-cdn.net`)
* `:port` - a `:inet.port_number` specifying a port where the imglab server is located.
* `:subdomains` - a `boolean` value specifying if the source should be specified using subdomains instead of using the path. (default: `true`)

If we have our on-premises imglab server at `http://my-company.com:8080` with a source named `images` we can use the following source settings to access a `logo.png` image:

```elixir
"images"
|> Imglab.Source.new(https: false, host: "my-company.com", port: 8080)
|> Imglab.url("logo.png", width: 300, height: 300, format: :png)
"http://images.my-company.com:8080/logo.png?width=300&height=300&format=png"
```

It is possible to use secure sources too:

```elixir
"images"
|> Imglab.Source.new(https: false, host: "my-company.com", port: 8080, secure_key: "images-secure-key", secure_salt: "images-secure-salt")
|> Imglab.url("logo.png", width: 300, height: 300, format: :png)
"http://images.my-company.com:8080/logo.png?width=300&height=300&format=png&signature=generated-signature"
```

### Using sources with disabled subdomains

In the case that your on-premises imglab server is configured to use source names as paths instead of subdomains you can set `subdomains` attribute to `false`:

```elixir
"images"
|> Imglab.Source.new(https: false, host: "my-company.com", port: 8080, subdomains: false)
|> Imglab.url("logo.png", width: 300, height: 300, format: :png)
"http://my-company.com:8080/images/logo.png?width=300&height=300&format=png"
```

## Generating srcsets

You can use `Imglab.srcset/3` function to generate custom string values for `srcset` attributes, to be used for Web responsive images inside a `<img>` tag.

This function works similarly to `Imglab.url/3`, expecting the same parameters and values, except for some specific query parameters that have a special meaning and can receive `Range` and lists as values.

> To learn more about responsive images and the `srcset` attribute, you can take a look to the [MDN article about responsive images](https://developer.mozilla.org/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images).

### Fixed size

When enough information is provided about the image output size (using `width` or `height` parameters), `srcset` function will generate URLs with a default sequence of device pixel ratios:

For the following example we are specying a fixed value of `500` pixels for `width` parameter:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 500)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1 1x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2 2x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3 3x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=4 4x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=5 5x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=6 6x
```

A very common practice consists in reducing the quality of images with high pixel density, decreasing the final file size. To achieve this you can optionally specify an Elixir `Range` value for `quality` parameter, gradually reducing the file size while increasing the image size.

In this example we are specifying a fixed `width` value of `500` pixels and a `quality` interval between `80` and `40`:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 500, quality: 80..40)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=500&quality=80&dpr=1 1x,
https://assets.imglab-cdn.net/image.jpeg?width=500&quality=70&dpr=2 2x,
https://assets.imglab-cdn.net/image.jpeg?width=500&quality=61&dpr=3 3x,
https://assets.imglab-cdn.net/image.jpeg?width=500&quality=53&dpr=4 4x,
https://assets.imglab-cdn.net/image.jpeg?width=500&quality=46&dpr=5 5x,
https://assets.imglab-cdn.net/image.jpeg?width=500&quality=40&dpr=6 6x
```

A custom `Range` value can be set for `dpr` parameter too, overriding the default sequence of generated dprs:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 500, dpr: 1..4)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1 1x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2 2x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3 3x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=4 4x
```

Using `Range` values for `dpr` and `quality` parameters in the same `srcset` call is also possible:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 500, dpr: 1..4, quality: 80..40)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1&quality=80 1x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2&quality=63 2x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3&quality=50 3x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=4&quality=40 4x
```

If necessary you can also use lists with explicit values for `dpr` and `quality`:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 500, dpr: [1, 2, 3], quality: [80, 75, 60])
```

```
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1&quality=80 1x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2&quality=75 2x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3&quality=60 3x
```

Or even use a specific `quality` value for all the URLs in the same srcset:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 500, dpr: [1, 2, 3], quality: 70)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1&quality=70 1x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2&quality=70 2x,
https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3&quality=70 3x
```

### Fluid width

When a specific sequence of widths is required you can use a `Range`, `Imglab.Sequence`, or list for `width` parameter.

When a `Range` value is used, a sequence with a default size of 16 URLs will be generated inside the specified interval:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 100..2000)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=100 100w,
https://assets.imglab-cdn.net/image.jpeg?width=122 122w,
https://assets.imglab-cdn.net/image.jpeg?width=149 149w,
https://assets.imglab-cdn.net/image.jpeg?width=182 182w,
https://assets.imglab-cdn.net/image.jpeg?width=222 222w,
https://assets.imglab-cdn.net/image.jpeg?width=271 271w,
https://assets.imglab-cdn.net/image.jpeg?width=331 331w,
https://assets.imglab-cdn.net/image.jpeg?width=405 405w,
https://assets.imglab-cdn.net/image.jpeg?width=494 494w,
https://assets.imglab-cdn.net/image.jpeg?width=603 603w,
https://assets.imglab-cdn.net/image.jpeg?width=737 737w,
https://assets.imglab-cdn.net/image.jpeg?width=900 900w,
https://assets.imglab-cdn.net/image.jpeg?width=1099 1099w,
https://assets.imglab-cdn.net/image.jpeg?width=1341 1341w,
https://assets.imglab-cdn.net/image.jpeg?width=1638 1638w,
https://assets.imglab-cdn.net/image.jpeg?width=2000 2000w
```

If required you can specify a `Range` value for `quality` parameter too:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 100..2000, quality: 80..40)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=100&quality=80 100w,
https://assets.imglab-cdn.net/image.jpeg?width=122&quality=76 122w,
https://assets.imglab-cdn.net/image.jpeg?width=149&quality=73 149w,
https://assets.imglab-cdn.net/image.jpeg?width=182&quality=70 182w,
https://assets.imglab-cdn.net/image.jpeg?width=222&quality=66 222w,
https://assets.imglab-cdn.net/image.jpeg?width=271&quality=63 271w,
https://assets.imglab-cdn.net/image.jpeg?width=331&quality=61 331w,
https://assets.imglab-cdn.net/image.jpeg?width=405&quality=58 405w,
https://assets.imglab-cdn.net/image.jpeg?width=494&quality=55 494w,
https://assets.imglab-cdn.net/image.jpeg?width=603&quality=53 603w,
https://assets.imglab-cdn.net/image.jpeg?width=737&quality=50 737w,
https://assets.imglab-cdn.net/image.jpeg?width=900&quality=48 900w,
https://assets.imglab-cdn.net/image.jpeg?width=1099&quality=46 1099w,
https://assets.imglab-cdn.net/image.jpeg?width=1341&quality=44 1341w,
https://assets.imglab-cdn.net/image.jpeg?width=1638&quality=42 1638w,
https://assets.imglab-cdn.net/image.jpeg?width=2000&quality=40 2000w
```

If you want to generate a sequence of numbers for `width` parameter with a specific number of URLs you can use `sequence` function helper:

```elixir
# Remember to import Imglab.Sequence before using sequence/3 helper function
import Imglab.Sequence

# Generating a srcset string with a sequence of 5 URLs between 100 and 2000 pixels for width parameter
Imglab.srcset("assets", "image.jpeg", width: sequence(100, 2000, 5))
```

```
https://assets.imglab-cdn.net/image.jpeg?width=100 100w,
https://assets.imglab-cdn.net/image.jpeg?width=211 211w,
https://assets.imglab-cdn.net/image.jpeg?width=447 447w,
https://assets.imglab-cdn.net/image.jpeg?width=946 946w,
https://assets.imglab-cdn.net/image.jpeg?width=2000 2000w
```

Using a list with specific values will generate URLs only for those widths:

```elixir
Imglab.srcset("assets", "image.jpeg", width: [100, 300, 500])
```

```
https://assets.imglab-cdn.net/image.jpeg?width=100 100w,
https://assets.imglab-cdn.net/image.jpeg?width=300 300w,
https://assets.imglab-cdn.net/image.jpeg?width=500 500w
```

It is also possible to specify a list of values for `height` and `quality` parameters:

```elixir
Imglab.srcset("assets", "image.jpeg", width: [100, 300, 500], height: [200, 400, 600], quality: [75, 70, 65])
```

```
https://assets.imglab-cdn.net/image.jpeg?width=100&height=200&quality=75 100w,
https://assets.imglab-cdn.net/image.jpeg?width=300&height=400&quality=70 300w,
https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&quality=65 500w
```

### No size

When `srcset` function doesn't have information about the image output size (`width` or `height` parameters are not set) it will generate a default sequence of 16 URLs specifying a `width` value with an interval between `100` and `8192` pixels:

```elixir
Imglab.srcset("assets", "image.jpeg")
```

```
https://assets.imglab-cdn.net/image.jpeg?width=100 100w,
https://assets.imglab-cdn.net/image.jpeg?width=134 134w,
https://assets.imglab-cdn.net/image.jpeg?width=180 180w,
https://assets.imglab-cdn.net/image.jpeg?width=241 241w,
https://assets.imglab-cdn.net/image.jpeg?width=324 324w,
https://assets.imglab-cdn.net/image.jpeg?width=434 434w,
https://assets.imglab-cdn.net/image.jpeg?width=583 583w,
https://assets.imglab-cdn.net/image.jpeg?width=781 781w,
https://assets.imglab-cdn.net/image.jpeg?width=1048 1048w,
https://assets.imglab-cdn.net/image.jpeg?width=1406 1406w,
https://assets.imglab-cdn.net/image.jpeg?width=1886 1886w,
https://assets.imglab-cdn.net/image.jpeg?width=2530 2530w,
https://assets.imglab-cdn.net/image.jpeg?width=3394 3394w,
https://assets.imglab-cdn.net/image.jpeg?width=4553 4553w,
https://assets.imglab-cdn.net/image.jpeg?width=6107 6107w,
https://assets.imglab-cdn.net/image.jpeg?width=8192 8192w
```

It is always possible to change this default behavior using `sequence` function helper. In the following example we are specifying a sequence of 10 different URLs between `320` and `4096` pixels:

```elixir
import Imglab.Sequence

Imglab.srcset("assets", "image.jpeg", width: sequence(320, 4096, 10))
```

```
https://assets.imglab-cdn.net/image.jpeg?width=320 320w,
https://assets.imglab-cdn.net/image.jpeg?width=425 425w,
https://assets.imglab-cdn.net/image.jpeg?width=564 564w,
https://assets.imglab-cdn.net/image.jpeg?width=749 749w,
https://assets.imglab-cdn.net/image.jpeg?width=994 994w,
https://assets.imglab-cdn.net/image.jpeg?width=1319 1319w,
https://assets.imglab-cdn.net/image.jpeg?width=1751 1751w,
https://assets.imglab-cdn.net/image.jpeg?width=2324 2324w,
https://assets.imglab-cdn.net/image.jpeg?width=3086 3086w,
https://assets.imglab-cdn.net/image.jpeg?width=4096 4096w
```

### Image aspect ratio and srcset

A usual scenario is to generate multiple URLs while maintaining the same aspect ratio for all of them. If a specific image aspect ratio is required while using `srcset` function you can set a value to `aspect-ratio` parameter along with `mode` parameter using  `crop`, `contain`, `face`, or `force` resize modes.

For the following example we are using a specific value of `300` pixels for `width` and an aspect ratio of `1:1` (square), cropping the image with `crop` resize mode and setting output format to `webp`:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 300, aspect_ratio: "1:1", mode: :crop, format: :webp)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=300&aspect-ratio=1%3A1&mode=crop&format=webp&dpr=1 1x,
https://assets.imglab-cdn.net/image.jpeg?width=300&aspect-ratio=1%3A1&mode=crop&format=webp&dpr=2 2x,
https://assets.imglab-cdn.net/image.jpeg?width=300&aspect-ratio=1%3A1&mode=crop&format=webp&dpr=3 3x,
https://assets.imglab-cdn.net/image.jpeg?width=300&aspect-ratio=1%3A1&mode=crop&format=webp&dpr=4 4x,
https://assets.imglab-cdn.net/image.jpeg?width=300&aspect-ratio=1%3A1&mode=crop&format=webp&dpr=5 5x,
https://assets.imglab-cdn.net/image.jpeg?width=300&aspect-ratio=1%3A1&mode=crop&format=webp&dpr=6 6x
```

You can instead use `height` value. In this example we are specifying a fixed value of `300` pixels for `height` parameter, a `aspect-ratio` of `16:9` (widescreen) with `crop` resize mode, and `webp` output format:

```elixir
Imglab.srcset("assets", "image.jpeg", height: 300, aspect_ratio: "16:9", mode: :crop, format: :webp)
```

```
https://assets.imglab-cdn.net/image.jpeg?height=300&aspect-ratio=16%3A9&mode=crop&format=webp&dpr=1 1x,
https://assets.imglab-cdn.net/image.jpeg?height=300&aspect-ratio=16%3A9&mode=crop&format=webp&dpr=2 2x,
https://assets.imglab-cdn.net/image.jpeg?height=300&aspect-ratio=16%3A9&mode=crop&format=webp&dpr=3 3x,
https://assets.imglab-cdn.net/image.jpeg?height=300&aspect-ratio=16%3A9&mode=crop&format=webp&dpr=4 4x,
https://assets.imglab-cdn.net/image.jpeg?height=300&aspect-ratio=16%3A9&mode=crop&format=webp&dpr=5 5x,
https://assets.imglab-cdn.net/image.jpeg?height=300&aspect-ratio=16%3A9&mode=crop&format=webp&dpr=6 6x
```

You can also use fluid values for `width` parameter while maintaining the same aspect ratio for all generated URLs. In this example, we are using a `range` value between `100` and `4096` for `width` parameter, a value of `1:1` for `aspect-ratio`, `crop` resize mode and `webp` output format:

```elixir
Imglab.srcset("assets", "image.jpeg", width: 100..4096, aspect_ratio: "1:1", mode: :crop, format: :webp)
```

```
https://assets.imglab-cdn.net/image.jpeg?width=100&aspect-ratio=1%3A1&mode=crop&format=webp 100w,
https://assets.imglab-cdn.net/image.jpeg?width=128&aspect-ratio=1%3A1&mode=crop&format=webp 128w,
https://assets.imglab-cdn.net/image.jpeg?width=164&aspect-ratio=1%3A1&mode=crop&format=webp 164w,
https://assets.imglab-cdn.net/image.jpeg?width=210&aspect-ratio=1%3A1&mode=crop&format=webp 210w,
https://assets.imglab-cdn.net/image.jpeg?width=269&aspect-ratio=1%3A1&mode=crop&format=webp 269w,
https://assets.imglab-cdn.net/image.jpeg?width=345&aspect-ratio=1%3A1&mode=crop&format=webp 345w,
https://assets.imglab-cdn.net/image.jpeg?width=442&aspect-ratio=1%3A1&mode=crop&format=webp 442w,
https://assets.imglab-cdn.net/image.jpeg?width=566&aspect-ratio=1%3A1&mode=crop&format=webp 566w,
https://assets.imglab-cdn.net/image.jpeg?width=724&aspect-ratio=1%3A1&mode=crop&format=webp 724w,
https://assets.imglab-cdn.net/image.jpeg?width=928&aspect-ratio=1%3A1&mode=crop&format=webp 928w,
https://assets.imglab-cdn.net/image.jpeg?width=1188&aspect-ratio=1%3A1&mode=crop&format=webp 1188w,
https://assets.imglab-cdn.net/image.jpeg?width=1522&aspect-ratio=1%3A1&mode=crop&format=webp 1522w,
https://assets.imglab-cdn.net/image.jpeg?width=1949&aspect-ratio=1%3A1&mode=crop&format=webp 1949w,
https://assets.imglab-cdn.net/image.jpeg?width=2497&aspect-ratio=1%3A1&mode=crop&format=webp 2497w,
https://assets.imglab-cdn.net/image.jpeg?width=3198&aspect-ratio=1%3A1&mode=crop&format=webp 3198w,
https://assets.imglab-cdn.net/image.jpeg?width=4096&aspect-ratio=1%3A1&mode=crop&format=webp 4096w
```

## License

imglab source code is released under [MIT License](LICENSE).
