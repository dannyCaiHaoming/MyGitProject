


### 这里用的是类似VUE的实现方式，将每一段的视频以及每一段的过渡效果视频，作为一个单独的Composition，然后播放的时候串行播放


1. 将需要处理的PlayItem传入GMCompositionService，然后会根据PlayItem的类型，生成Composition
2. 由于存在过渡效果，因此，有几种情况
（1）视频A + 视频B  ，2个视频都是使用默认长度3s
（2）视频A + 过渡 + 视频B，2个视频的长度都需要裁剪，视频A需要裁剪使用0-2s，视频B需要使用1-3s

3. 过渡Composition需要传入前一段视频和后一段视频才能生成该Composition
4. 在使用`makePlayable`方法的时候，会生成一个数组的`AVPlayItem`，提供给`AVQueuePlayer`使用


ps : 这个示例中存在存储视频的Composition是`GMBasicComposition`，表示1s过渡效果视频的Composition是`GMTransitionComposition`
而图层Layer是使用的类别的方式加上去，这里往后可以看看如何优化。



