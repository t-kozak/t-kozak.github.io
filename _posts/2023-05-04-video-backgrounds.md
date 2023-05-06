---
layout: post
title:  "HTML5 Video backgrounds"
date:   2023-05-03T17:25:52-05:00
author: Ted K.
categories: Software
---

In digital age, having an engaging and visually appealing website is crucial for your online presence. 
Nowadays, with the rise of video content everywhere, visially appealing means having video content of some 
sorts.

This post will cover that very subject the why and how to include a video as a medium on your landing page. 
Specifically, we'll show how to achieve a full viewport (full page) background videos in a sensible way from
the human interface, network performance and portability perspectives.

If you are a marketing person, startup founder or in simillar work - this is for you. Check the 
[demo](https://world.teds-stuff.xyz/video_background_sample/) to see if you like it and ask your front-end gal
to make it happen.

If you are that front end gal - this post is for you as well as it talks about the technical details on how to
implement this technique in an efficient and portable way. Although, you may want to go straight to the [GitHub repo](https://github.com/t-kozak/video_background_sample).


## Why video background? 

if "a picture is worth a thousand words<sup><a href="#references">1</a></sup>", then a video clip is worth `1k * FPS * duration` words! 

Jokes aside video content is great at captivating your audience. The large scale video backgrounds can help 
you elicit the emotion that you want people to feel to associate with your brand. Yes, you can total achieve
similar results with staic images, videos are just that bit better (opinion).

Additionally, since digital presence is a standard, adding some more video content to your website can elevate
your brand that bit above the average, above the baseline. It may not matter for a high tech entities from 
which that level of technical excellence is expected, but the your for your local honey manufacturer nice 
touches like these can have a significant impact on brand perception.

Finally, a video background can give your website that extra wow! factor cheaper than with other means like
animations or dynamic HTML/JS/CSS components. Due to the prevailance of video content, finding right stock 
footage or even social media content can be easier and cheaper than the investemnt in an artist's time. 

## Why not?

I can identify a few potential problems with the use of the video backgrounds. 

The first issue the comes to my mind is simply an extra effort required. The media assets have to be created
and then transcoded to web-optimised formats. Ideally you want to create 2 variants of the content one 
optimised for portrait and the other for landscape orientations. It just adds up.

Then, there is the problem with the extra bandwidth. It's not a surprise that video files are heavier 
than static images. This can affect the experience of people opening your webpage as well as your 
operational
costs through higher bandwidth bill. That being said, the size of the video assets is something you have a 
full control over and it is possible to find that sweet spot perceived quality of the media and the assets 
size. Additionally, with the use of modern video codecs (more below) and potentially some clever 
application of blurring and darkening, this can be mitigated.

## What's in store for me?

Through this "editorial piece", we'll demostrate how to create the following website:

<video muted loop playsinline autoplay width="222" style="margin: 10px auto;"
        poster="{{ site.baseurl }}/assets/posts/html5vid/webpage.webp">
        <source src="{{ site.baseurl }}/assets/posts/html5vid/webpage_hevc.mp4"
          type='video/mp4; codecs="hvc1"' />
        <source src="{{ site.baseurl }}/assets/posts/html5vid/webpage_vp9.webm"
        type="video/webm" />
        <source src="{{ site.baseurl }}/assets/posts/html5vid/webpage_avc.mp4" 
        type="video/mp4" />
</video>

From technology perspective, the solution offers following features:
- separate videos for portrait and lanscape orientation. For devices with screen aspect ratio higher 
  than 1.0 a portrait videos will be used. For smaller or equal - a portrait
- three video formats for each orientation - HEVC, VP9 and AVC
- delayed loading of videos to give the browser enough time to fetch other content before the heavy videos
- dynamically selected poster, again for portrait and landscape orientations

## Content Preparation

It is 2023, and both landscape and portrait orientations are essential for video content. This means your 
video content must be high quality in both orientations, and simply cropping a landscape video into a portrait
format is no longer sufficient.

Fortunately, plenty of stock footage is available in both orientations—it just requires a bit more effort 
to find and edit. While some tools, like Apple iMovie, don't support portrait orientation, alternatives like 
DaVinci Resolve or Canva can be used to edit your video content effectively.

## Encoding

Before diving into encoding, being familiar with terms like video codec, AVC, HEVC, WebM, and others is 
essential. If you need a refresher, check out this informative video: 

<iframe width="560" height="315" src="https://www.youtube.com/embed/XvoW-bwIeyY" title="YouTube video player" 
		frameborder="0" 
		allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
		allowfullscreen>
</iframe>


During the 2010s, web browsers experienced a form of video 
[codec wars](https://taylor.callsen.me/how-cisco-ended-the-html5-video-codec-wars/). 
As a result, it's necessary to support multiple codecs and formats to achieve the best quality and coverage. 
In this example, we'll be supporting the following:

- H.264/AVC in mp4 container. It is supported everywhere and provides acceptable quality.
- H.265/HEVC in mp4: It is supported by Apple (mobile Safari, desktop Safari) and offers vastly better 
  quality to bitrate ratio than H.264.
- VP9 in WebM container Supported and preferred on Android devices and desktop Chromium based browsers. 

We'll use FFmpeg for all transcoding, following a workflow that involves creating large source video assets 
(portrait + landscape) and running a script to downscale and convert them to the desired format. When 
installing Ffmpeg, make sure that you do so with the support of libx264 and libx265, which may be off by 
default, depending on your platform and region.

To transcode your videos, use the 
script below, which utilises default parameters and produces three video clips and two poster images (first 
frames of each video) for smoother loading.

```bash
#!/bin/zsh


# For boring stuff like input parsing, default values, error check see the full script on GitHub
# =================

vid_file=$(basename ${input_vid})
vid_name=${vid_file%.*}

echo "Transcoding $input_vid -> $out_dir/${vid_name}.{webp,_hevc.mp4,_avc.mp4,.webm}"

# Extract first frame for the poster
do_exec "ffmpeg -y -i $input_vid -vframes 1  -f image2 -vf "$video_filter" ${out_dir}/${vid_name}.jpg"

# Convert it to WebP, because we're cool kids
do_exec "ffmpeg -y -i ${out_dir}/${vid_name}.jpg ${out_dir}/${vid_name}.webp"

# Transcode to H.264/AVC
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libx264    -vf "$video_filter" -b:v ${avc_rate}  -preset slower -pix_fmt yuv420p ${out_dir}/${vid_name}_avc.mp4"

# Transcode to H.265/HEVC. Please note the use of tag:v hvc1 - this is the format supported by Apple devices.
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libx265    -vf "$video_filter" -b:v ${hevc_rate} -preset slower -tag:v hvc1      ${out_dir}/${vid_name}_hevc.mp4"

# # Transcode to VP9, two passes
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libvpx-vp9 -vf "$video_filter" -b:v ${webm_rate} -pass 1  -f null /dev/null"
do_exec "ffmpeg -y -i $input_vid ${no_audio} -c:v libvpx-vp9 -vf "$video_filter" -b:v ${webm_rate} -pass 2  ${out_dir}/${vid_name}_vp9.webm"

```

## Presentation

You’ll need some HTML5, CSS, and JS magic to showcase your stunning video backgrounds. I believe in 
self-explanatory commented code, see the relevant parts below:

#### HTML

```html

<!-- The section with inspiring words and the video background -->
<section class="hero">

<!--
Wrapper for the video background. Needed to ensure the aspect ratio and centering the
video box
-->
  <div class="hero-bg">

	<!-- 
The king of this show - the video tag. Couple of notes:
- the video must be muted in order to be autoplayed. If you don't add the "muted" attribute
even if the video does not contain audio track, browser will not autoplay it with error 
"I don't want to bother my dear human with the noise of your crappy video. You want to play 
the clip make sure that human presses the play button" or so.
- the poster we're using is just a transparent gif. This technique allows us to dynamically
select the backround poster - either for portrait or landscape video clip. See style.css,
specifically ".hero-bg video" sections for more context
-->
    <video muted loop playsinline
	poster="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">

	<!-- 
We're providing the browser with 3 sources and let it pick the preferred one. We have 
videos encoded with HEVC, VP9 and AVC respectively. 

Each video source tag does not specify the source directly, but instead uses "data-src" 
and "data-portrait-src". This allows us  to first defer fetching of the videos until all 
of the page is loaded (poster will be displayed until it happens). 

It also makes it possible to select a video files with correct orientation (portrait and 
landscape).

Final important thing to note is the use of codecs="hvc1" parameter of the first source 
type. This clarification is necessary as by default browsers assume video/mp4 is video 
file encoded with AVC rather than HEVC. In result browsers/platforms not supporting HEVC 
playback (e.g. Chrome) will try to play the file and fail miserabely. 

See the loader.js for more on how the video files are loaded and played
-->
	  <source data-src="assets/bg_hevc.mp4" data-portrait-src="assets/bg_portrait_hevc.mp4"
		type='video/mp4; codecs="hvc1"' />
	  <source data-src="assets/bg_vp9.webm" data-portrait-src="assets/bg_portrait_vp9.webm" type="video/webm" />
	  <source data-src="assets/bg_avc.mp4" data-portrait-src="assets/bg_portrait_avc.mp4" type="video/mp4" />
    </video>
  </div>

<!-- All the elements below are not relevant for the demo purposes. It's just filler content. -->
  <div class="hero-content">
	<h1>Some inspiring text<br>goes here</h1>
	<p>With some more explaining words maybe. I really don' t know</p>
  </div>
</section>

<!-- 
A in-flow gap between the top of the viewport and the top of the scrollable page content. Allows the
non-hero content to cover the hero section.
-->
<div class="gap-for-hero"></div>

```

#### CSS

```css
html,
body {
    /* Make sure that the video takes all of the viewport. */
    margin: 0;

    /* 
    We're disabling the default mobile overscrol behaviour to prevent the default rubber-band type scroll 
    effect. With that effect in place, human can see the video content when scrolling to the end of content 
    and then pulling up. Ideally I'd like to add an empty box at the end of the content that matches the color
    of the last content item - I just don't know how to do it.
    */
    overscroll-behavior-y: none;
}

/* 
The hero section is fixed and takes all of the view port. This creates the effect of being covered by reminder 
of the content as human scrolls the page down 
 */
.hero {
    position: fixed;
    width: 100%;
    height: 100vh;
}

/* 
The container for the background video. Make it absolute and "lower" on z-axis, make it take all the space 
and clip any overflowing content (to maintain aspect ratio of the video tag inside).
 */
.hero-bg {
    z-index: -1;
    position: absolute;
    overflow: hidden;
    width: 100%;
    height: 100%;
}

/* 
The star of the show - background video. 
Position is absolutely and use top+left+transform to center it on the x axis.
Use of min-width, min-height being 100% and specific aspect ratio ensure the video fills the container fully
while aspect ratio is maintained. That way, any aspect ratio mismatches are fixed by overflowing and clipping 
excess content. Please note that the aspect ratio is for portrait by default and for landscape we use media 
query to overwrite it.

The background size 100% in both axes ensures the background poster fills all of the video tag box.

Finally we have background image for the actual portrait poster. Again overriden in the media query selector
for a landscape. 

Finally finally, to make things a bit more consistent and allow readable white text on top of moving videos 
we dim the video a bit with filter:brightness.

 */
.hero-bg video {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);

    min-height: 100%;
    min-width: 100%;
    aspect-ratio: calc(9/16);

    background-size: 100% 100%;
    background-image: url('assets/bg_portrait.webp');

    filter: brightness(50%);

}

/* 
For __devices__ (not viewports) with aspect ratio 1 or more (aka landscape) change the video poster and 
video's aspect ratio.

It's important to use device's aspect ratio and not viewports as this prevents change to config with the 
resize of the browser window. Just makes things simpler.

Also it's important to note that this value must match what's used in the loader.js for consistency. The
loader.js uses it to control which video source to use, the CSS which poster.
*/

@media screen and (min-device-aspect-ratio: 1) {
    .hero-bg video {
        background-image: url('assets/bg.webp');
        aspect-ratio: calc(16/9);
    }
}

/* 
The hero content must be above the video background on z-axis. Make it white to look good on darkened video
also position it somewhere centrally while we're at it.
  */
.hero-content {
    z-index: 10;
    color: white;
    padding-top: 10%;
    padding-left: 20%;
}

/* 
Make sure that the gap for hero content covers most of the viewport y axis. We're leaving those 80pxs 
to allow the wave to portrude a bit, to indicate that there is some more action happening here and entice human
to scroll.
*/
.gap-for-hero {
    height: calc(100vh - 80px);
}

```

#### JavaScript

```javascript
const _srcAttrib = "data-src"
const _srcAttribPortrait = "data-portrait-src"

// must match what is used in style.css as media query
const _landscapeMinAR = 1.0

// Main function that loads all videos. Useful with any video tag, not only the background. Can be simplified
// if you're dealing just with the background video.
function loadVids() {
    console.log('Fetching them videos')
    let videos = document.getElementsByTagName('VIDEO')
    for (let i = 0; i < videos.length; i++) {
        _loadVid(videos[i])
    }
}


function _loadVid(video) {

    video.childNodes.forEach((srcNode) => {
        // go through all the sources and pick appropriate src file - either portrait or landscape
        if (srcNode.hasAttribute && srcNode.hasAttribute(_srcAttrib)) {
            srcNode.src = _getVidSrc(srcNode)
        }
    })

    function onErr(e) {
        console.log('Got vid error for')
        console.log(e.target.error.message)
    }

    // Autoplay. Please note that if you're using this script on a page with more video tags, you may want
    // to filter which videos are to be auto-played.
    function onLoaded(e) {
        video.play()
    }

    video.onerror = onErr
    video.onloadeddata = onLoaded

    video.load()
}


function _getVidSrc(sourceNode) {
    if (_isLandscape()) {
        return sourceNode.getAttribute(_srcAttrib)
    }
    return sourceNode.getAttribute(_srcAttribPortrait)
}

function _isLandscape() {
    let h = window.screen.availHeight
    let w = window.screen.availWidth
    return w / h > _landscapeMinAR;
}


// Give a page some time to init before loading really heavy videos.
window.setTimeout(loadVids, 500)
```

## Parting Words

I hope you enjoyed learning about HTML video backgrounds, and encourage you to check out our website where 
this method was applied: [FoodieApp](https://yourfoodie.app). Happy coding!


--------

#### References
1. [A picture is worth a thousand words. 2023, March 17. In Wikipedia.](https://en.wikipedia.org/wiki/A_picture_is_worth_a_thousand_words)