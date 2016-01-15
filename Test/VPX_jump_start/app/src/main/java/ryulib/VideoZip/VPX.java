package ryulib.VideoZip;

import android.graphics.Bitmap;

public class VPX {
	
	public static final int VPX_DL_REALTIME = 0;
	public static final int VPX_DL_GOOD_QUALITY = 1;
	public static final int VPX_DL_BEST_QUALITY = 2;
	
	static {
		System.loadLibrary("RyuVPX");	
	}
	
	public static native int OpenEncoder(int width, int height, int bitRate, int fps, int gop);
	public static native void CloseEncoder(int handle);	
	public static native int EncodeBitmap(int handle, Bitmap bitmap, byte[] buffer, int bufferSize, int deadline);	

	public static native int OpenDecoder(int width, int height);
	public static native void CloseDecoder(int handle);
	public static native void InitDecoder(int handle);
	
	public static native int DecodeBitmap(int handle, Bitmap bitmap, byte[] buffer, int bufferSize);

}
