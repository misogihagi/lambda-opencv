FROM lambci/lambda:build-python3.8

ENV OPENCV_VERSION 4.5.0


RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

RUN mkdir opencv/cache/xfeatures2d/boostdesc -p
RUN mkdir opencv/cache/xfeatures2d/vgg -p
WORKDIR opencv/cache/xfeatures2d/boostdesc
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_lbgm.i > boostdesc_lbgm.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_binboost_256.i > boostdesc_binboost_256.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_binboost_128.i > boostdesc_binboost_128.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_binboost_064.i > boostdesc_binboost_064.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_bgm_hd.i > boostdesc_bgm_hd.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_bgm_bi.i > boostdesc_bgm_bi.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_bgm.i > boostdesc_bgm.i
WORKDIR ../vgg
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_120.i > vgg_generated_120.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_64.i > vgg_generated_64.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_48.i > vgg_generated_48.i
RUN curl https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_80.i > vgg_generated_80.i

WORKDIR ../../../

RUN cp ./cache/xfeatures2d/boostdesc/* ../opencv_contrib/modules/xfeatures2d/src/
RUN cp ./cache/xfeatures2d/vgg/* ../opencv_contrib/modules/xfeatures2d/src/

RUN ls -l /var/task/opencv_contrib/modules/xfeatures2d/src/
RUN yum install -y cmake3

RUN pip install --upgrade pip&& pip install numpy

RUN mkdir build 
RUN cp -r modules/features2d build
WORKDIR build 
RUN cmake3 \
    -DBUILD_SHARED_LIBS=NO \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=../../python \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -DPYTHON3_EXECUTABLE=/var/lang/bin/python .. \
  && make install
  

RUN find ../../python/lib/python3.8 -name *.so | xargs -n 1 strip -s

RUN mkdir /var/task/dist

RUN cp ../../python/lib/python3.8/site-packages/cv2/python-3.8/* /var/task/dist

WORKDIR /var/task/dist

RUN pip install numpy -t .

RUN mkdir /var/task/output
CMD cp -r /var/task/dist/ /var/task/output/

