import java.nio.ByteOrder;
import java.nio.charset.Charset;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

public class EchoServerHandler extends ChannelInboundHandlerAdapter {

	private final static AttributeKey<Integer> id = AttributeKey.valueOf("id");

	@Override
	public void handlerAdded(ChannelHandlerContext ctx) throws Exception {
		ctx.attr(id).set(ctx.hashCode());
		
		System.out.println("handlerAdded" + ctx.hashCode());

		super.handlerAdded(ctx);
	}

	@Override
	public void handlerRemoved(ChannelHandlerContext ctx) throws Exception {
		System.out.println("handlerRemoved");

		super.handlerRemoved(ctx);
	}

	@Override
	public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
		ByteBuf buffer = ((ByteBuf) msg).order(ByteOrder.LITTLE_ENDIAN);		
	
		System.out.println(buffer.readUnsignedByte());
		System.out.println(buffer.readUnsignedByte());
		System.out.println(buffer.readUnsignedByte());
		System.out.println(buffer.readUnsignedByte());
		System.out.println(buffer.readUnsignedShort());
		System.out.println("....");
		
		
//		String text = buffer.toString(Charset.defaultCharset());
//		System.out.print(text);
//		ctx.write(msg);
	}

	@Override
	public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
		ctx.flush();
	}

}
