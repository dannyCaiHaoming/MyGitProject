


### 这里是用了旧的Composition组合方式（类似AVFoundation秘籍中的Demo），将N段视频，作为一个完整的Composition处理。

### 使用Builder类，传入PlayItem内容，生成一段用于播放或者导出的视频Composition数据

### ps:由于是使用工厂将所需要的材料（视频数据，过渡效果，图层内容）生成一个完整Composition，因此，想要对每一段进行单独自定义操作比较困难


直接将PlayItem遍历，然后定义CompositionTrack，如果需要过渡效果则需要2个视频的CompositionTrack

因此，如果需要多合一视频进行过渡，这里的CompositionTrack处理起码可能会存在麻烦。

另外，由于如果使用2个视频的CompositionTrack去做过渡效果，例如CompositionTrackA，CompositionTrackB，
那么，自动生成出来的VideoCompositionInstruction中的两个VideoCompositionLayerInstruction，就需要注意先后顺序。


CompositionTrackA: [```Video1```]      [```Video3```]

CompositionTrackB:           [```Video2```]


如上，第一个组合的VideoCompositionInstruction,是Video1和Video2交错的地方，FrontVideoCompositionLayerInstructin是Video1,BackVideoCompositionLayerInstruction是Video2
第二个组合的VideoCompositionInstruction,是Video2和Video3交错的地方，FrontVideoCompositionLayerInstructin是Video2,BackVideoCompositionLayerInstruction是Video3


