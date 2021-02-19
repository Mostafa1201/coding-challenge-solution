package com.localytics.interview;

import java.io.IOException;
import java.nio.file.Paths;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

public class SolutionsTest extends TestCase {
    public SolutionsTest( String testName ) {
        super( testName );
    }

    public static Test suite(){
        return new TestSuite( SolutionsTest.class );
    }

    public void testSolutions() throws IOException {
        Solutions.solve();
    }
}
