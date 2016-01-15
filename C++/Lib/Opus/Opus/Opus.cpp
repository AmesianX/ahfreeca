// Opus.cpp : DLL 응용 프로그램을 위해 내보낸 함수를 정의합니다.
//

#include "stdafx.h"
#include "opus.h"

extern "C" __declspec(dllexport) void *openEncoder(int *pErrorCode, int sampleRate, int channels, int bitrate)
{
	OpusEncoder *pHandle;

	pHandle = opus_encoder_create(sampleRate, channels, OPUS_APPLICATION_AUDIO, pErrorCode);
	if (*pErrorCode < 0) return NULL;

	*pErrorCode = opus_encoder_ctl(pHandle, OPUS_SET_BITRATE(bitrate));
	if (*pErrorCode < 0) {
		opus_encoder_destroy(pHandle);
		return NULL;
	}

	return (void *)pHandle;
}

extern "C" __declspec(dllexport) int encode(OpusEncoder *pHandle, unsigned char pDataIn[], int sizeIn, void *pBufferOut, int bufferSize)
{
	int frameSize = sizeIn / 2;
	return opus_encode(pHandle, (opus_int16 *)pDataIn, frameSize, (unsigned char *)pBufferOut, bufferSize);
}

extern "C" __declspec(dllexport) void closeEncoder(OpusEncoder *pHandle)
{
	opus_encoder_destroy(pHandle);
}

extern "C" __declspec(dllexport) void *openDecoder(int *pErrorCode, int sampleRate, int channels)
{
	OpusDecoder *pHandle;

	pHandle = opus_decoder_create(sampleRate, channels, pErrorCode);
	if (*pErrorCode < 0) return NULL;

	return (void *)pHandle;
}

extern "C" __declspec(dllexport) int decode(OpusDecoder *pHandle, void *pDataIn, int sizeIn, unsigned char pBufferOut[], int bufferSize)
{
	return opus_decode(pHandle, (unsigned char *)pDataIn, sizeIn, (opus_int16 *)pBufferOut, bufferSize / 2, 0) * 2;
}

extern "C" __declspec(dllexport) void closeDecoder(OpusDecoder *pHandle)
{
	opus_decoder_destroy(pHandle);
}


