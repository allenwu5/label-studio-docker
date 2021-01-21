FROM heartexlabs/label-studio AS base

FROM base AS mmdetection
RUN apt-get update -y \
&&  apt-get install git -y \
&&  apt-get install wget -y \
&&  apt-get install python3-opencv -y
RUN pip install --upgrade pip
# Cannot install https://github.com/heartexlabs/label-studio/blob/master/label_studio/ml/examples/mmdetection/requirements.txt
# Need to install it separately
RUN pip install torchvision==0.8.1 mmcv-full==1.1.6

FROM mmdetection AS mmdetection2
# Cannot install mmdetection in /label-studio/label_studio/ml/examples/mmdetection/requirements.txt
# Need to install it separately
RUN git clone https://github.com/open-mmlab/mmdetection.git
RUN cd mmdetection \
&&  pip install -r requirements/build.txt \
&&  pip install -v -e .

FROM mmdetection2 AS yolo3
RUN cd /label-studio
RUN mkdir checkpoints
# Add more models here when needed
RUN wget http://download.openmmlab.com/mmdetection/v2.0/yolo/yolov3_d53_mstrain-608_273e_coco/yolov3_d53_mstrain-608_273e_coco-139f5633.pth -P checkpoints

# CMD ["/apache-tomcat-7.0.82/bin/catalina.sh", "run"]