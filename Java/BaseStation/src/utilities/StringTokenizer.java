/*
* Copyright (c) 2006 Sun Microsystems, Inc.
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to 
* deal in the Software without restriction, including without limitation the 
* rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
* sell copies of the Software, and to permit persons to whom the Software is 
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in 
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
* DEALINGS IN THE SOFTWARE.
 **/       
package org.sunspotworld.demo.utilities;

import java.util.Vector;

/**
 * A utitlity class that pbreaks a string into pieces, using a 
 * given deliemiter chracter as a break point.
 * @author randy
 */
public class StringTokenizer {
    
    /** Creates a new instance of StringTokenizer */
    public StringTokenizer() {
    }
    
    public static String selectToken(String input, int index){
        return (String)(parseString(input, " ").elementAt(index));
    }
       
    public static Vector parseString(String input){
        return parseString(input, " ");
    }
    
    /**
     *  This and the next are the smain methods to call. The delimiter specifies the break point.
     *  The collection of resulting tokesn is returned.
     **/
    public static Vector parseString(String input, String delimiter){ 
        Vector tokens = new Vector();
        int pos = 0;
        int len = input.length();
        
        while (pos < len) {
            String next = "";
            // index pos to first non-delimiter character...
            if (pos < len && delimiter.indexOf(input.charAt(pos)) >= 0) {
                while (++pos < len && delimiter.indexOf(input.charAt(pos)) >= 0);
            }
            // if pos is not at the end of the string...
            if (pos < len) {
                int start = pos;
                // find the next delimiter
                while (++pos < len && delimiter.indexOf(input.charAt(pos)) < 0);
                next = input.substring(start, pos);
            }
            if (next != "") {
                tokens.addElement(next);
            }
        }
        return tokens;
    }
    
    /**
     * return the results of the above parseString() method, only as an Array not a Vector.
     **/
    public static String[] parseStringAsArray(String input, String delimiter){
        Vector v = parseString(input, delimiter);
        String[] r = new String[v.size()];
        for (int i = 0; i < r.length; i++) {
            r[i] = (String)(v.elementAt(i));
        }
        return r;
    }
}
