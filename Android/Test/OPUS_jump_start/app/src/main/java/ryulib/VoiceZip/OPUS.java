package ryulib.VoiceZip;

/**
 * Created by Ryu on 2016-01-16.
 */
public class OPUS {

    static {
        System.loadLibrary("RyuOPUS");
    }

    public static native int OpenEncoder(int sampleRate, int channels, int bitrate);
    public static native void CloseEncoder(int handle);
    public static native int Encode(int handle, byte[] dataIn, int sizeIn, byte[] bufferOut, int bufferSize);

    public static native int OpenDecoder(int sampleRate, int channels);
    public static native void CloseDecoder(int handle);
    public static native int Decode(int handle, byte[] dataIn, int sizeIn, byte[] bufferOut, int bufferSize);

}
