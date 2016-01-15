#include <jni.h>
#include <android/log.h>
#include "opus.h"


JNIEXPORT jint Java_ryulib_VoiceZip_OPUS_OpenEncoder(JNIEnv* env, jclass clazz, 
	jint *pErrorCode, jint sampleRate, jint channels, jint bitrate)
{
	OpusEncoder *pHandle;

	pHandle = opus_encoder_create(sampleRate, channels, OPUS_APPLICATION_AUDIO, pErrorCode);
	if (*pErrorCode < 0) return 0;

	*pErrorCode = opus_encoder_ctl(pHandle, OPUS_SET_BITRATE(bitrate));
	if (*pErrorCode < 0) {
		opus_encoder_destroy(pHandle);
		return 0;
	}

	return (int) pHandle;
}

JNIEXPORT jint Java_ryulib_VoiceZip_OPUS_Encode(JNIEnv* env, jclass clazz, 
	jint handle, jbyteArray dataIn, jint sizeIn, jbyteArray *bufferOut, int bufferSize)
{
	OpusEncoder *pHandle = (OpusEncoder *) handle;

	opus_int16 *pDataIn = (opus_int16 *) (*env)->GetByteArrayElements(env, dataIn, 0);
	unsigned char *pBufferOut = (unsigned char *) (*env)->GetByteArrayElements(env, bufferOut, 0);

	int frameSize = sizeIn / 2;

	int result = opus_encode(pHandle, pDataIn, frameSize, pBufferOut, bufferSize);

	(*env)->ReleaseByteArrayElements(env, dataIn, (jbyte *) pDataIn, 0);
	(*env)->ReleaseByteArrayElements(env, bufferOut, (jbyte *) pBufferOut, 0);

	return result;
}

JNIEXPORT void Java_ryulib_VoiceZip_OPUS_CloseEncoder(JNIEnv* env, jclass clazz, 
	jint handle)
{
	OpusEncoder *pHandle = (OpusEncoder *) handle;

	opus_encoder_destroy(pHandle);
}

JNIEXPORT jint Java_ryulib_VoiceZip_OPUS_OpenDecoder(JNIEnv* env, jclass clazz, 
	jint *pErrorCode, jint sampleRate, jint channels)
{
	OpusDecoder *pHandle;

	pHandle = opus_decoder_create(sampleRate, channels, pErrorCode);
	if (*pErrorCode < 0) return 0;

	return (int) pHandle;
}

JNIEXPORT jint Java_ryulib_VoiceZip_OPUS_Decode(JNIEnv* env, jclass clazz, 
	jint handle, jbyteArray dataIn, jint sizeIn, jbyteArray bufferOut, jint bufferSize)
{
	OpusDecoder *pHandle = (OpusDecoder *) handle;

	unsigned char *pDataIn = (unsigned char *) (*env)->GetByteArrayElements(env, dataIn, 0);
	opus_int16 *pBufferOut = (opus_int16 *) (*env)->GetByteArrayElements(env, bufferOut, 0);

	int result = opus_decode(pHandle, pDataIn, sizeIn, pBufferOut, bufferSize / 2, 0) * 2;

	(*env)->ReleaseByteArrayElements(env, dataIn, (jbyte *) pDataIn, 0);
	(*env)->ReleaseByteArrayElements(env, bufferOut, (jbyte *) pBufferOut, 0);

	return result;
}

JNIEXPORT void Java_ryulib_VoiceZip_OPUS_CloseDecoder(JNIEnv* env, jclass clazz, 
	jint handle)
{
	OpusDecoder *pHandle = (OpusDecoder *) handle;

	opus_decoder_destroy(pHandle);
}