// VideoZip.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "stdlib.h"
#include "stdio.h"
#include "wchar.h"
#include "stdarg.h"
#include "WinBase.h"

#include "VideoZip.h"
#include "yuvTools.h"

#define interfaceEnc (vpx_codec_vp8_cx())
#define interfaceDec (vpx_codec_vp8_dx())

const vpx_img_fmt _PixelFormat = VPX_IMG_FMT_I420;
const int _PixelSize = 4;

void trace(const char* format, ...) {
	char buffer[4096];
	va_list vaList;
	va_start(vaList, format);
	_vsnprintf(buffer, 4096, format, vaList);
	va_end(vaList);
	OutputDebugStringA(buffer);
}

extern "C" __declspec(dllexport) void *openEncoder(int *errorCode, int width, int height, int bitRate, int gop) {
	*errorCode = 0;

	VideoZipHandle *pHandle = (VideoZipHandle *) malloc(sizeof(VideoZipHandle));

	if (!vpx_img_alloc(&pHandle->img, _PixelFormat , width, height, 1)) {
		*errorCode = _Error_Allocate_Image;
		goto error;
	}

	if (vpx_codec_enc_config_default(interfaceEnc, &pHandle->cfgEnc, 0)) {
		*errorCode = _Error_Getting_Config;
		goto error;
	}

	// CPU 성능에 맞춰서 스레드 수 조정
	SYSTEM_INFO siSysInfo;
	GetSystemInfo(&siSysInfo); 
	pHandle->cfgEnc.g_threads = siSysInfo.dwNumberOfProcessors * 2;

	pHandle->cfgEnc.g_pass = VPX_RC_ONE_PASS;
	pHandle->cfgEnc.rc_dropframe_thresh = 0;
	pHandle->cfgEnc.rc_end_usage = VPX_CBR;
	pHandle->cfgEnc.rc_min_quantizer = 8;
	pHandle->cfgEnc.rc_max_quantizer = 56;
	pHandle->cfgEnc.rc_undershoot_pct = 100;
	pHandle->cfgEnc.rc_overshoot_pct  = 0;

	#ifdef _DEBUG
		trace("pHandle->cfgEnc.g_threads: %d", pHandle->cfgEnc.g_threads);
	#endif 	

	if (0 != bitRate) {
		pHandle->cfgEnc.rc_target_bitrate = bitRate;
	} else {
		pHandle->cfgEnc.rc_target_bitrate = width * height * pHandle->cfgEnc.rc_target_bitrate  / pHandle->cfgEnc.g_w / pHandle->cfgEnc.g_h;    
	}

	pHandle->cfgEnc.g_w = width;
	pHandle->cfgEnc.g_h = height;

	if (0 != gop) {
		pHandle->cfgEnc.kf_max_dist = gop;
	} 
	
	if (-1 == gop) {
		pHandle->cfgEnc.kf_mode = VPX_KF_DISABLED;
	}

	if (vpx_codec_enc_init(&pHandle->codec, interfaceEnc, &pHandle->cfgEnc, 0)) {
		*errorCode = _Error_Init_VideoCodec;
		goto error;
	}

	return pHandle;

	error:
	vpx_img_free(&pHandle->img);
	vpx_codec_destroy(&pHandle->codec);
	free(pHandle);
	return NULL;
}

extern "C" __declspec(dllexport) void closeEncoder(VideoZipHandle *pHandle) {
	vpx_img_free(&pHandle->img);
	vpx_codec_destroy(&pHandle->codec);
	free(pHandle);
}

extern "C" __declspec(dllexport) int encodeBitmap(VideoZipHandle *pHandle, void *pBitmap, void *pBuffer, int sizeOfBuffer, int deadline, long long *pts) {
	int packet_size = 0;
	int frame_cnt = 0;
	int flags = 0;

	unsigned long ulDeadline = VPX_DL_GOOD_QUALITY;

	switch (deadline)
	{
		case 0: ulDeadline = VPX_DL_REALTIME; break;
		case 1: ulDeadline = VPX_DL_GOOD_QUALITY; break;
		case 2: ulDeadline = VPX_DL_BEST_QUALITY; break;
	}

	RGBtoYUV420((unsigned char*) pBitmap, pHandle->img.planes[0], pHandle->cfgEnc.g_w, pHandle->cfgEnc.g_h, _PixelSize);
	if (vpx_codec_encode(&pHandle->codec, &pHandle->img, frame_cnt, 1, flags, ulDeadline)) {
		return packet_size;
	}

	const vpx_codec_cx_pkt_t *pPacket;
	vpx_codec_iter_t iter = NULL;
	unsigned char *pFrame = (unsigned char *) pBuffer;
	int *pFrameSize;

	while ( (pPacket = (vpx_codec_get_cx_data(&pHandle->codec, &iter))) ) {
		*pts = pPacket->data.frame.duration;

		// sizeOfBuffer?? ????? ???????? ??????.
		if ((packet_size + sizeof(int) + pPacket->data.frame.sz) >= sizeOfBuffer) return packet_size;

		switch (pPacket->kind) {
			case VPX_CODEC_CX_FRAME_PKT:  
				pFrameSize = (int *) pFrame;
				*pFrameSize = pPacket->data.frame.sz;
				pFrame = pFrame + sizeof(int);

				memcpy(pFrame, pPacket->data.frame.buf, pPacket->data.frame.sz); 
				pFrame = pFrame + pPacket->data.frame.sz;

				packet_size = packet_size + sizeof(int) + pPacket->data.frame.sz;
				break;                                               

			default: break;
		}
	}

	return packet_size;
}

extern "C" __declspec(dllexport) void *openDecoder(int *errorCode, int width, int height)
{
	*errorCode = 0;

	VideoZipHandle *pHandle = (VideoZipHandle *) malloc(sizeof(VideoZipHandle));

	pHandle->cfgDec.w = width;
	pHandle->cfgDec.h = height;
	pHandle->cfgDec.threads = 16;

	int flags = 0;

	if (vpx_codec_dec_init(&pHandle->codec, interfaceDec, &pHandle->cfgDec, flags)) {
		*errorCode = _Error_Init_VideoCodec;
		goto error;
	}

	return pHandle;

	error:
	vpx_codec_destroy(&pHandle->codec);
	free(pHandle);
	return NULL;
}

extern "C" __declspec(dllexport) void closeDecoder(VideoZipHandle *pHandle)
{
	vpx_codec_destroy(&pHandle->codec);
	free(pHandle);
}

extern "C" __declspec(dllexport) void initDecoder(VideoZipHandle *pHandle) {
	int flags = 0;
	vpx_codec_dec_init(&pHandle->codec, interfaceDec, &pHandle->cfgDec, flags);
}

extern "C" __declspec(dllexport) char decodeBitmap(VideoZipHandle *pHandle, void *pBitmap, void *pBuffer, int sizeOfBuffer)
{
	char result = 0;

	unsigned char *pFrame = (unsigned char *) pBuffer;
	int *pFrameSize;
	int frameSize = 0;
	int count = 0;
	vpx_image_t *img;
	vpx_codec_iter_t iter;

	while (count < sizeOfBuffer) {
		pFrameSize = (int *) pFrame;
		frameSize = *pFrameSize;
		pFrame = pFrame + sizeof(int);

		if (vpx_codec_decode(&pHandle->codec, (unsigned char*) pFrame, frameSize, NULL, 0)) {
			return result;
		}
		pFrame = pFrame + frameSize;

		count = count + sizeof(int) + frameSize;

		iter = NULL;
		while((img = vpx_codec_get_frame(&pHandle->codec, &iter))) {
			I420ToARGB(
				(unsigned char *) img->planes[0], img->stride[0],
				(unsigned char *) img->planes[1], img->stride[1],
				(unsigned char *) img->planes[2], img->stride[2],
				(unsigned char *) pBitmap, 
				img->d_w * _PixelSize,
				img->d_w, img->d_h
			);

			result = 1;
		}
	}

	return result;
}
