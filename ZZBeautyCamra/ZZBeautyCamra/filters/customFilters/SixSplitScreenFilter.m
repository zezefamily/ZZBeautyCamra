//
//  SixSplitScreenFilter.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/28.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "SixSplitScreenFilter.h"

NSString * _Nullable const kSixSplitScreenFragmentShaderString = SHADER_STRING
(
  precision highp float;
  uniform sampler2D inputImageTexture;
  varying vec2 textureCoordinate;

  void main()
  {
      vec2 uv = textureCoordinate.xy;
      if(uv.y <= 0.5){
          uv.y = uv.y + 0.5;
      }
      if(uv.x <= 1.0/3.0){
          uv.x = uv.x + 1.0/3.0;
      }else if(uv.x > 1.0/3.0 && uv.x <= 2.0/3.0){
          uv.x = uv.x;
      }else{
          uv.x = uv.x - 1.0/3.0;
      }
      gl_FragColor = texture2D(inputImageTexture,uv);
  }
);

@implementation SixSplitScreenFilter

- (id)init
{
    if(!(self = [super initWithFragmentShaderFromString:kSixSplitScreenFragmentShaderString])){
        return nil;
    }
    return self;
}
@end
