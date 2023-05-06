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

## The Whys...

### Why video background? 

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

### Why not?

As with everything, there are a few potential problems with the use of the video backgrounds. 

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
 
After dealing with the What? and Why?, we'll address the How? of the soluction in the sections below.

## The Hows

### TL;DR

- use two different media assets for portrait and landscape.
- use some JavaScript maagic to choose which one to use based on device screen's AR; see repo for details
- use three different video codecs for each of the two assets
- AVC as baseline for wide support
- HEVC for Apple devices
- WebM for everyone else
- Use multiple ```<source>``` tags to let the browser choose which video codec it likes the most. See repo
  for more details

### Content Preparation

It is 2023, and both landscape and portrait orientations are essential for video content. This means your 
video content must be high quality in both orientations, and simply cropping a landscape video into a portrait
format is no longer sufficient.

Fortunately, plenty of stock footage is available in both orientations—it just requires a bit more effort 
to find and edit. While some tools, like Apple iMovie, don't support portrait orientation, alternatives like 
DaVinci Resolve or Canva can be used to edit your video content effectively.

The process of content creation is highly dependand on your needs and environment and thus will be left 
unaddressed.

### Encoding

Before diving into encoding, being familiar with terms like video codec, AVC, HEVC, WebM, and others is 
essential. If you need a refresher, check out this informative video: 

<iframe width="560" height="315" src="https://www.youtube.com/embed/XvoW-bwIeyY" title="YouTube video player" 
		frameborder="0" 
		allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
		allowfullscreen>
</iframe>


During the 2010s, web browsers experienced a form of "video codec wars"<sup><a href="#references">2,3
</a></sup>. 
As a result, it's necessary to support multiple codecs and formats to achieve the best quality and coverage. 
In this example, we'll be supporting three codecs: AVC, HEVC, and VP9.

#### AVC

AVC, Advanced Video Coding aka H.264, introduced in 2004<sup><a href="#references">4</a></sup>, is the oldest 
of the video codecs we'll be supporting. It also happens to be the most widely adopted video format at the 
time of writing with approximately 98% of people using Internet able to consume AVC content<sup><a 
href="#references">5</a></sup>. Finally, with the technology behind AVC being so mature, AVC is the most 
efficient format, from the perspective of battery life.

The age of this video format indeed shows, with content encoded using AVC needing approximately 50% more 
bandwidth to achieve similar perceived quality as media encoded using the more recently developed 
codecs<sup><a href="#references">6,7,8</a></sup>. 

In 2023, the use of AVC is more of a backup format, a way to cover the baseline of "older devices", given 
it's ubiquity. That being said, since the size of media processed with it is significant, one may question if
it's not better to simply fallback to a static image in this case. Especially that the use of "older devices"
can be correlated with worse connectivity, which may overal lead to a worse experience than when using just 
an image.  

#### VP9

VP9, aka VP9 

#### HEVC

Some may find the Inclusion of an HEVC, the High Efficiency Video Coding, aka H.265<sup><a 
href="#references">9</a></sup> format questionable, as its use is limited mostly to Apple software 
(Safari and Chrome on macOS/iOS)<sup><a href="#references">10</a></sup>.

The decision to use it is mostly driven by the fact that it offers the best quality to bitrate ratio in most
cases (although the difference is negligble), while at the same time offering better energy efficiency on the 
devices supporting it. Even with support recently added to Safari<sup><a href="#references">11</a>
</sup> (and AV1 it's successor), the support is patchy and most likely limited to software decoding, 
especially on mobile<sup>(citation needed)</sup>. Software decoding is orders of magnitude more energy intensive than the use of dedicated hardware<sup>(citation needed)</sup>.


#### Encoding itself

We'll use FFmpeg for all transcoding, following a workflow that involves creating large source video assets 
(portrait + landscape) and running a script to downscale and convert them to the desired format. When 
installing Ffmpeg, make sure that you do so with the support of libx264 and libx265, which may be off by 
default, depending on your platform and region.

To transcode your videos, use the 
script below, which utilises default parameters and produces three video clips and two poster images (first 
frames of each video) for smoother loading.


### Presentation

You’ll need some HTML5, CSS, and JS magic to showcase your stunning video backgrounds. I believe in 
self-explanatory commented code, see the relevant parts below:


## Parting Words

I hope you enjoyed learning about HTML video backgrounds, and encourage you to check out our website where 
this method was applied: [FoodieApp](https://yourfoodie.app). Happy coding!


--------

#### References
1. [A picture is worth a thousand words. 2023, March 17. In Wikipedia.](https://en.wikipedia.org/wiki/A_picture_is_worth_a_thousand_words)
2. [Google's WebM v H.264: who wins and loses in the video codec wars? 2011, January 17 In The Guardian](https://www.theguardian.com/technology/blog/2011/jan/17/google-webm-vp8-video-html5-h264-winners-losers)
3. [How Cisco ended the HTML5 Video Codec Wars. 2023, February 27. In Taylor Callsen's Blog.](https://taylor.callsen.me/how-cisco-ended-the-html5-video-codec-wars/)
4. [Advanced Video Coding. (2023, April 20). In Wikipedia.](https://en.wikipedia.org/wiki/Advanced_Video_Coding)
5. [Can I use... avc?, 2023, May 5th](https://caniuse.com/?search=avc)
6. [H.265 HEVC vs H.264 AVC: 50% bit rate savings verified. 2016, January 12. BBC Research & Development Blog](https://www.bbc.co.uk/rd/blog/2016-01-h264-h265-avc-advanced-video-coding-hevc-high-efficiency)
7. [Netflix Finds VP9 Offers Strong Compression At 1080p, Approaches HEVC Performance. 2016, August 30. Tom's hardware](https://www.tomshardware.com/news/netflix-tests-vp9-hevc-codecs,32580.html)
8. [Performance comparison of video coding standards: an adaptive streaming perspective. 2018, December 13. Netflix Technology Blog](https://netflixtechblog.com/performance-comparison-of-video-coding-standards-an-adaptive-streaming-perspective-d45d0183ca95)
9. [High Efficiency Video Coding. 2023, April 22. In Wikipedia.](https://en.wikipedia.org/wiki/High_Efficiency_Video_Coding)
10. [Can I use... hevc?, 2023, May 5th](https://caniuse.com/?search=hevc)
11. [Apple adds WebM video playback support to Safari with macOS Big Sur 11.3. 2021, February 18th. 9to5 Mac](https://9to5mac.com/2021/02/18/apple-adds-webm-video-playback-support-to-safari-with-macos-big-sur-11-3/)
12. [VP9. (2023, May 5). In Wikipedia.](https://en.wikipedia.org/wiki/VP9)
