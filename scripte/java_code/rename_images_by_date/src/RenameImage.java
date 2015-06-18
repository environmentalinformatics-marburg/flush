
import java.io.File;
import java.io.IOException;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.metadata.IIOMetadata;
import javax.imageio.stream.ImageInputStream;
import com.drew.imaging.jpeg.JpegMetadataReader;
import com.drew.imaging.jpeg.JpegProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import com.drew.metadata.exif.ExifReader;

import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;


public class RenameImage {
	
	public void checkRec(File dir){
		
		for (File entry: dir.listFiles()) {
			//File f = new File(entry);
			this.renameFile(entry);
			System.out.println(entry.getAbsolutePath());
			if (entry.isDirectory()) {
				this.checkRec(entry);
			}
		}
	}

	public void renameFile(File file) {
		try {
			ExifReader ex = new ExifReader();
			 ImageInputStream iis = ImageIO.createImageInputStream(file);
	            Iterator<ImageReader> readers = ImageIO.getImageReaders(iis);
	            Metadata readMetadata = JpegMetadataReader.readMetadata(file);
	            System.out.println(readMetadata);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	  void displayMetadata(Node root) {
	        displayMetadata(root, 0);
	    }

	    void indent(int level) {
	        for (int i = 0; i < level; i++)
	            System.out.print("    ");
	    }

	    void displayMetadata(Node node, int level) {
	        // print open tag of element
	        indent(level);
	        System.out.print("<" + node.getNodeName());
	        NamedNodeMap map = node.getAttributes();
	        if (map != null) {

	            // print attribute values
	            int length = map.getLength();
	            for (int i = 0; i < length; i++) {
	                Node attr = map.item(i);
	                System.out.print(" " + attr.getNodeName() +
	                                 "=\"" + attr.getNodeValue() + "\"");
	            }
	        }

	        Node child = node.getFirstChild();
	        if (child == null) {
	            // no children, so close element and return
	            System.out.println("/>");
	            return;
	        }

	        // children, so close current tag
	        System.out.println(">");
	        while (child != null) {
	            // print children recursively
	            displayMetadata(child, level + 1);
	            child = child.getNextSibling();
	        }

	        // print close tag of element
	        indent(level);
	        System.out.println("</" + node.getNodeName() + ">");
	    }
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
	   RenameImage rI = new RenameImage();
	   File dir = new File ("/home/dogbert/workspace/images");
	   rI.checkRec(dir);
			
	}

}
