# Lyricist

[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/akshatvg/Lyricist?logo=github&style=social)](https://github.com/akshatvg/) [![GitHub last commit](https://img.shields.io/github/last-commit/akshatvg/Lyricist?style=social&logo=git)](https://github.com/akshatvg/) [![GitHub stars](https://img.shields.io/github/stars/akshatvg/Lyricist?style=social)](https://github.com/akshatvg/Lyricist/stargazers) [![GitHub forks](https://img.shields.io/github/forks/akshatvg/Lyricist?style=social&logo=git)](https://github.com/akshatvg/Lyricist/network) [![Netlify Status](https://api.netlify.com/api/v1/badges/710e7028-fea0-41d1-a1aa-e636386222b7/deploy-status)](https://app.netlify.com/sites/lyricist-agora/deploys)


Lyricist helps get musical notes from online music classes automatically.

<p align="center">
<a href="https://lyricist.akshatvg.com">
<img src="https://lyricist.akshatvg.com/assets/img/logo.png" width="200px" height="200px" alt="Lyricist Logo"/>
</a>
</p>

![Generic badge](https://img.shields.io/badge/Lyricist-With_Agora-orange) 

## Inspiration
To make quarantine more productive, a mutual friend of our team, Ekaansh decided to start posting videos of him playing the guitar playing new tunes composed by him on his Instagram. His followers gave really positive responses and many of them even wanted his musical sheet notes so they could learn and try to recreate the soothing music. Making the notes manually is a very tedious task and hence when Ekaansh told us about what was happening, our team decided to make a cross platform (Web+ iOS+ Android) application to solve his problem.

## What it does
Lyricist helps download musical notes from online music classes automatically with just the click of a button or even view the notes in real time.

## How we built it
We use Agora to send the Audio stream to be transcribed and Audio Notes are hence generated using which we request our backend to send the exact Musical Notes. Our backend scrapes through a well-reputed website and using Selenium replies back to the frontend of the website and app with the required Musical Sheet.

## Challenges we ran into
Deployment of the backend server which generates the Music Sheet is a problem and hence this works only on localhost for now. This is why while testing the Sheet Generation, you'll have to run the code locally but you can see the UI of the whole code including the Livestream using Agora and Note Generation on the hosted site.

## Accomplishments that we're proud of
We came up with this idea and built it from scratch in less than two days due to exams in our college during the rest of the hackathon.

## What we learned
Music! A lot of music! We had no clue learning how to play music could be this challenging!

## Steps to run the Server
```bash
$ git clone https://github.com/Meherdeep/RTE-Hack
$ cd RTE-Hack
$ pip3 install -r requirements.txt
$ python3 -m uvicorn server:app --reload
```

## Useful Links
- [Lyricist Website](https://lyricist.akshatvg.com)
- [Agora.io Website](https://www.agora.io)
- [Demo Video](https://vimeo.com/449633557)

## Requirements
-  [x] Agora RTC SDK (or <a href="https://github.com/akshatvg/Agora-RTC-CDN">CDN</a>)
-  [x] Agora App ID
-  [x] AWS Account
-  [x] Jupyter Notebook
-  [x] FAST API requirements (requirements.txt)

```bash
 _____ _                 _     __   __            
|_   _| |               | |    \ \ / /            
  | | | |__   __ _ _ __ | | __  \ V /___  _   _   
  | | | '_ \ / _` | '_ \| |/ /   \ // _ \| | | |  
  | | | | | | (_| | | | |   <    | | (_) | |_| |  
  \_/ |_| |_|\__,_|_| |_|_|\_\   \_/\___/ \__,_|  
                                                  
                                                  
______                                            
|  ___|                                           
| |_ ___  _ __                                    
|  _/ _ \| '__|                                   
| || (_) | |                                      
\_| \___/|_|                                      
                                                  
                                                  
______      _               _   _               _ 
| ___ \    (_)             | | | |             | |
| |_/ / ___ _ _ __   __ _  | |_| | ___ _ __ ___| |
| ___ \/ _ \ | '_ \ / _` | |  _  |/ _ \ '__/ _ \ |
| |_/ /  __/ | | | | (_| | | | | |  __/ | |  __/_|
\____/ \___|_|_| |_|\__, | \_| |_/\___|_|  \___(_)
                     __/ |                        
                    |___/                         

```

## License

**GPL-3.0 &copy; [Akshat Gupta, Mehereep Thakur and Sai Sandeep](https://github.com/akshatvg/Lyricist/blob/master/LICENSE)**

[![GitHub license](https://img.shields.io/github/license/akshatvg/Lyricist?style=social&logo=github)](https://github.com/akshatvg/Lyricist/blob/master/LICENSE)

---------

```javascript

if (youEnjoyed) {
    starOurRepository();
}

```

-----------
