FROM fuzzers/afl:2.52 as builder

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev libpng-dev \ 
libx11-dev libgl-dev  libglu1-mesa libglu1-mesa-dev
ADD . /Mesh-processing-library
WORKDIR /Mesh-processing-library
COPY buildHarness/buildfuzz.sh .
RUN bash buildfuzz.sh

FROM fuzzers/afl:2.52
RUN apt-get update && apt-get install -y libglu1-mesa-dev libglu1-mesa libgl-dev \
libjpeg-dev libpng-dev
COPY --from=builder /Mesh-processing-library/bin/clang/Filterimage /
COPY --from=builder /Mesh-processing-library/demos/data/*.png /testsuite/
COPY --from=builder /usr/local/lib/* /usr/local/lib/

ENTRYPOINT ["afl-fuzz", "-i", "/testsuite/", "-o", "/meshprocesslibOut"]
CMD ["/Filterimage", "@@", "-to", "jpg", ">", "/dev/null"]
