---
layout: post
title:  "Robots Talk Art"
date:   2023-08-27T12:25:52+10:00
author: Ted K.
categories: Software Photography ML
cover: /assets/posts/ai_talks_art/cover.jpeg
---


As someone who has recently become a contributor to Getty's iStock photo service, I've been trying to justify
my escalating photo equipment purchases by transitioning to a "pro" photographer. I mean... if you make money
off of something, you're a "pro" at it, right 😜?. But, while the process sounds glamorous, there's an unsung 
hero in this story - metadata. The need to provide titles, descriptions, and a plethora of tags can be quite 
a chore.

Now, if you've been around engineers long enough, you know we have a special knack for automating the mundane. 
Since I was already keen on exploring the [Hugging Face](https://huggingface.co) platform, I thought, why not
see how these open-source models fare with object detection and captioning? Let me clarify - this was more of 
a fun experiment than an extensive research project. But as they say, every experiment is valuable, and mine
was no exception.

## Setup
For that project, I've used the following models: 

- [nlpconnect/vit-gpt2-image-captioning](https://huggingface.co/nlpconnect/vit-gpt2-image-captioning) - 
  captioning, the __"nlp:"__ comment on each image
- [microsoft/git-base-coco](https://huggingface.co/microsoft/git-base-coco) - captioning, the __"ms:"__ line comment on each image
- [facebook/detr-resnet-50](https://huggingface.co/facebook/detr-resnet-50) - object detection, the __"obj:"__ 
  comment

Additionally, as a visualization Hack, to make the results more digestible, I employed 
[Pillow library](https://python-pillow.org), to directly embed the AI-generated captions onto the images.

## The Findings
Prepare yourself for a mix of underwhelming, humorous, intriguing, and reflective results. You can check out 
the AI-captioned gallery for some chuckles and deep thoughts. 

<iframe src="https://photography.teds-stuff.xyz/frame/slideshow?key=F2xqRT&speed=5&transition=none&autoStart=0&captions=0&navigation=1&playButton=0&randomize=0&transitionSpeed=2" width="800" height="600" frameborder="no" scrolling="no"></iframe>


While the captions might not have been perfect, I stumbled upon some interesting observations:

#### Ease of Use
The Hugging Face platform and the [transformers](https://github.com/huggingface/transformers) package are 
remarkably user-friendly. The ease with which you can initiate a model and deploy it reminds me of using 
frameworks like "Spring" or "Ruby on Rails". It seems we might be on the cusp of a revolutionary phase where 
AI platforms serve as plug-and-play modules for bigger projects. If you're curious, you can take a look at my
[code](https://gist.github.com/t-kozak/3d9472d82aedfcc68bd6e5b2c96e5284) to see just how easy it was. Again
this was just an experiment and more likely than not, using transformers in any production environment is a
big no-no, but it still indicates the ease of use.

#### Performance Expectations
My MacBook Pro handled running three models with surprising grace. While the M2 MacBook Pro is undeniably 
powerful, I had braced myself for purchasing GPU resources from the Google Cloud Platform. Happily, that 
wasn't necessary.

#### Bias and Limitations
Probably the most valuable takeaway for me is the personal experience of the bias in the models. 

<a href="https://photography.teds-stuff.xyz/Personal/AI-Talks-Art/n-4R6jDq/i-GPXW2s6/A"><img src="https://photos.smugmug.com/photos/i-GPXW2s6/0/4ec10cba/L/i-GPXW2s6-L.jpg" alt=""></a>

One of the photos depicts a hopping kangaroo. Where you see a 'roo, the machine sees zebras or hyenas... 
In another one, there is a bunch of termite mounds. Where you see termite mounds, AI sees a herd of 
elephants. Suffice it to say, the models I've been interrogating, never saw a kangaroo or termite mound in 
their "life" and it shows. 

This was the first direct experience for me of a problem I've only heard of before - the implicit biases that
are embedded in the ML models we train.

That prompted me to wonder if the job of a librarian of the future is curating ML models to make sure that the
collective knowledge and experience of a given country (society) is well represented and understood in the
digital world.

## Conclusions

While my experiment was light-hearted, it opened a window to the fascinating world of AI and its implications. 
The ease of use and performance of models have undoubtedly improved, but there's much work to be done in terms
of refining accuracy and representation. As the digital age progresses, ensuring that AI understands the
diverse experiences and knowledge of various societies might just be the next big challenge. After all, we
don't want a future where kangaroos are mistaken for zebras, do we? 😉

As for the problem that initiated this exploration, captioning the photos for iStock, I've ended up working
on them manually. I decided that this work is the extra value I can provide to make my "art" stand out more
and be a tiny bit more easy to discover. It's a bit more personal and I like it!

Oh and, if you're interested in seeing my iStock portfolio, here's the link: 
[https://www.istockphoto.com/portfolio/tedk](https://www.istockphoto.com/portfolio/tedk). It's still very much
a work in progress. For more complete gallery of my "work" just use the Photography link on top.



<!-- {% comment %} 

Talking points
- I recently became a contributor to Getty's iStock photo service. Trying to become a "pro" photographer to
  justify photo equipment purchases 😜
- The less glamorous side of this endeavor is the need to provide metadata - title, description and tags.
  A lot of tags...
- Since this is kind of tedious and I'm kind of a lazy engineer, and I was already on the lookout for some 
  opportunity to play with the Hugging Face platform - I decided to see how good is are the open-source models at
  object detection and captioning.
- Just to be clear, it was supposed to be a quick and dirty hack and test to "play" with the technology rather 
  than extensive research, comparison etc. There's nothing scientific in the process, nevertheless, I ended 
  up with some interesting findings and thoughts.
- For that project, I've used the following models: microsoft/git-base-coco (captioning), 
  nlpconnect/vit-gpt2-image-captioning (captioning) and microsoft/git-base-coco (object detection)
- To easily see the results, I then use Python PIL to embed the AI opinions on the images onto the files (hack)
- The results are simply underwhelming, but also funny, interesting and thought-provoking; see for yourself in the gallery below:
- On top of seeing the inadequacy of the freely available models for the tasks, there are some other findings I discovered
- First, it surprised me how easy it is to use the platform. The transformers package deals with almost all of 
  the complexity of fetching and initiating the model; the API to use it is also a breeze. One of the aims of 
  this project was to see if we're at the "Spring framework" or "Tomcat" or "Ruby on Rails" moment for AI where
  you can use frameworks as they are, as building blocks of something bigger, without fully knowing what's 
  happening inside. The answer would be - yes, no, maybe? Yes - it's that easy to use. No - it's the defaults are
  not good enough and probably not usable in commercial products. Maybe - I'm not sure yet how difficult it is to
  fine-tune the default models. See the code here to get a better feel of how easy is easy.
- Second - this stuff is lighter than I thought. I was surprised that I could efficiently run 3 models on my
  MacBook Pro. Sure M2 MBP is a beast, but still... I fully expected to need to buy some GPU of Google Cloud Platform.
- Third and probably most profound is the personal experience of bias of the models. In one of the photos, there
  is a hopping kangaroo. Where you may see a 'roo, the machine sees zebras or hyenas. In another one, there is
  a bunch of termite mounds. Where you see termite mound, AI sees a herd of elephants. Suffice it to say, the models
  I've been interrogating never saw a kangaroo or termite mound in their "life". That prompted me to wonder if the job of a librarian of the future is curating ML models to make sure that the collective knowledge and experience of a given country (society) is well represented and understood in the digital world.


{% endcomment %}
 -->