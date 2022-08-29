FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev libpng-dev libx11-dev libgl-dev  libglu1-mesa libglu1-mesa-dev
RUN git clone https://github.com/hhoppe/Mesh-processing-library.git
WORKDIR /Mesh-processing-library
COPY buildHarness/buildfuzz.sh .
RUN bash buildfuzz.sh
RUN mkdir /meshpngCorpus
#RUN cp ./demos/data/*.png /meshpngCorpus
RUN cp ./demos/data/texture.input.png /meshpngCorpus
RUN cp ./demos/data/gcanyon_sq129_b44.elev.png /meshpngCorpus
RUN cp ./demos/data/gcanyon_elev_crop.bw.png /meshpngCorpus
RUN wget https://filesamples.com/samples/image/png/sample_640%C3%97426.png
RUN cp *.png /meshpngCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/meshpngCorpus", "-o", "/meshprocesslibOut"]
CMD ["/Mesh-processing-library/bin/clang/Filterimage", "@@", "-to", "jpg", ">", "out.jpg"]
