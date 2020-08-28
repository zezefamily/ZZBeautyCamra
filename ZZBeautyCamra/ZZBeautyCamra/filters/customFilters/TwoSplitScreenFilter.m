//
//  TwoSplitScreenFilter.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/28.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "TwoSplitScreenFilter.h"

NSString * _Nullable const kTwoSplitScreenFragmentShaderString = SHADER_STRING
(
  precision highp float;
  uniform sampler2D inputImageTexture;
  varying vec2 textureCoordinate;

  void main()
  {
      vec2 uv = textureCoordinate.xy;
      float y;
      if(uv.y >= 0.0 && uv.y <= 0.5){
          y = uv.y + 0.5;
      }else{
          y = uv.y;
      }
      gl_FragColor = texture2D(inputImageTexture,vec2(uv.x,y));
  }
);

/*
 NSString *const kGPUImagePassthroughFragmentShaderString = SHADER_STRING
 (
  varying highp vec2 textureCoordinate;
  
  uniform sampler2D inputImageTexture;
  
  void main()
  {
      gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
  }
 );
 
 
 NSString *const kGPUImageVertexShaderString = SHADER_STRING
 (
  attribute vec4 position;
  attribute vec4 inputTextureCoordinate;
  
  varying vec2 textureCoordinate;
  
  void main()
  {
      gl_Position = position;
      textureCoordinate = inputTextureCoordinate.xy;
  }
 );
 
 */
@implementation TwoSplitScreenFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kTwoSplitScreenFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end
