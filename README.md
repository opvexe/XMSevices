Android 发送的语音格式为Android默认的 amr 格式，iOS 发送的格式为iOS默认的 wav 格式转 amr 格式(iOS优先为Android适配，原因是wav文件比较大，amr文件小，传送速度快)。

Android 接收到 iOS 发送的语音，原则上播放没有问题；iOS 接收到 Android 发送的语音，可能会出现两种情况：

1. 播放有杂音；

2. 不能播放，原因是 Android 所发送的语音虽然是 amr 格式，其实是 MPEG-4 格式，可以下载 mediainfo for Mac ，对比录制的 amr 参数是否一致。

以上两种情况，极大可能是因为 Android 中 MediaRecorder 的录制参数有问题以及输出文件格式设置错误，所以只要将 MediaRecorder 的音频设置，设置为 AMR 即可。

Android 端相关参考代码：

// 设置所录制的声音的采样率。
mMediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
//设置音频文件的编码：AAC/AMR_NB/AMR_MB/Default 声音的（波形）的采样
mMediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.AMR_NB);
// 设置输出文件的格式：THREE_GPP/MPEG-4/RAW_AMR/Default THREE_GPP(3gp格式，H263视频/ARM音频编码)、MPEG-4、RAW_AMR(只支持音频且音频编码要求为AMR_NB)
mMediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
// 文件保存地址及名字
targetFile = new File(targetDir, targetName);
//设置输出文件的路径
mMediaRecorder.setOutputFile(targetFile.getPath());
// 设置录制的音频通道数
mMediaRecorder.setAudioChannels(1);
// 设置所录制的声音的采样率。
mMediaRecorder.setAudioSamplingRate(8000);
// 设置所录制的声音的编码位率。
mMediaRecorder.setAudioEncodingBitRate(64);
