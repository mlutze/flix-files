/*
 * Copyright 2021 Nina Andrup Pedersen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

mod TestFile {

    use Files.{exists, isDirectory, isRegularFile, isReadable, isSymbolicLink,
        isWritable, isExecutable, readLines, readLinesWith, read, readWith,
        readLinesIter, readLinesIterWith, readBytes, readBytesWith, readChunks,
        stat, accessTime, creationTime, modificationTime, size}

    /////////////////////////////////////////////////////////////////////////////
    // accessTime                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testAccessTime01(): Bool \ IO =
        Result.isOk(accessTime("test-resources/file.txt"))

    /////////////////////////////////////////////////////////////////////////////
    // creationTime                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testCreationTime01(): Bool \ IO =
        Result.isOk(creationTime("test-resources/file.txt"))

    /////////////////////////////////////////////////////////////////////////////
    // modificationTime                                                        //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testModificationTime01(): Bool \ IO =
        Result.isOk(modificationTime("test-resources/file.txt"))

    /////////////////////////////////////////////////////////////////////////////
    // size                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testSize01(): Bool \ IO =
        Result.isOk(size("test-resources/file.txt"))

    /////////////////////////////////////////////////////////////////////////////
    // stat                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testStat01(): Bool \ IO =
        Result.isOk(stat("test-resources/file.txt"))

    @test
    def testStat02(): Bool \ IO =
        match stat("test-resources/file.txt") {
            case Ok(v) => v#fileType == Files.FileType.File
            case _ => false
        }

    /////////////////////////////////////////////////////////////////////////////
    // exists                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testExists01(): Bool \ IO =
        exists("./test-resources/file.txt") == Ok(true)

    @test
    def testExists02(): Bool \ IO =
        exists("./faketest-resources/file.txt") == Ok(false)

    /////////////////////////////////////////////////////////////////////////////
    // isDirectory                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testIsDirectory01(): Bool \ IO =
        isDirectory("./test-resources/directory") == Ok(true)

    @test
    def testIsDirectory02(): Bool \ IO =
        isDirectory("./test-resources/file.txt") == Ok(false)

    /////////////////////////////////////////////////////////////////////////////
    // isRegularFile                                                           //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testIsRegularFile01(): Bool \ IO =
        isRegularFile("./test-resources/directory") == Ok(false)

    @test
    def testIsRegularFile02(): Bool \ IO =
        isRegularFile("./test-resources/file.txt") == Ok(true)

    /////////////////////////////////////////////////////////////////////////////
    // isReadable                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testIsReadable01(): Bool \ IO =
        isReadable("./test-resources/file.txt") == Ok(true)

    @test
    def testIsReadable02(): Bool \ IO =
        isReadable("./faketest-resources/file.txt") == Ok(false)

    /////////////////////////////////////////////////////////////////////////////
    // isSymbolicLink                                                          //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testIsSymbolicLink(): Bool \ IO =
        isSymbolicLink("./test-resources/file.txt") == Ok(false)

    /////////////////////////////////////////////////////////////////////////////
    // isWritable                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testIsWritable01(): Bool \ IO =
        isWritable("./test-resources/file.txt") == Ok(true)

    @test
    def testIsWritable02(): Bool \ IO =
        isWritable("./faketest-resources/file.txt") == Ok(false)

    /////////////////////////////////////////////////////////////////////////////
    // isExecutable                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testIsExecutable(): Bool \ IO =
        isExecutable("./faketest-resources/file.txt") == Ok(false)

    /////////////////////////////////////////////////////////////////////////////
    // readLines                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadLines01(): Bool \ IO =
        Result.isOk(readLines("./test-resources/file.txt"))

    /////////////////////////////////////////////////////////////////////////////
    // readLinesWith                                                           //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadLinesWith01(): Bool \ IO =
        Result.isOk(readLinesWith({charSet = "UTF8"}, "./test-resources/file.txt"))

    /////////////////////////////////////////////////////////////////////////////
    // read                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testRead01(): Bool \ IO =
        Result.isOk(read("./test-resources/file.txt"))

    /////////////////////////////////////////////////////////////////////////////
    // readWith                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadWith01(): Bool \ IO =
        Result.isOk(readWith({offset = 2i64, count = 2, charSet = "UTF8"}, "./test-resources/file.txt"))

    @test
    def testReadWith02(): Bool \ IO =
        readWith({offset = 2i64, count = 2, charSet = "US-ASCII"}, "./test-resources/file.txt") == Ok("is")

    @test
    def testReadWith03(): Bool \ IO =
        readWith({offset = 0i64, count = 0, charSet = "US-ASCII"}, "./test-resources/file.txt") == Ok("")

    @test
    def testReadWith04(): Bool \ IO =
        readWith({offset = -10i64, count = 0, charSet = "US-ASCII"}, "./test-resources/file.txt") == Ok("")

    @test
    def testReadWith05(): Bool \ IO =
        Result.isErr(readWith({offset = 0i64, count = -100, charSet = "US-ASCII"}, "./test-resources/file.txt"))

    @test
    def testReadWith06(): Bool \ IO =
        Result.isErr(readWith({offset = -10i64, count = 10, charSet = "US-ASCII"}, "./test-resources/file.txt"))


    /////////////////////////////////////////////////////////////////////////////
    // readLinesIter                                                           //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadLinesIter01(): Bool \ IO = region rc {
        let iter = readLinesIter(rc, "./test-resources/file.txt");
        match Iterator.next(iter) {
            case Some(Ok(_)) => true
            case _           => false
        }
    }


    @test
    def testReadLinesIter02(): Bool \ IO = region rc {
        let iter = readLinesIter(rc, "./test-resources/file.txt");
        discard Iterator.next(iter);
        match Iterator.next(iter) {
            case Some(Ok(_)) => true
            case _           => false
        }
    }

    /////////////////////////////////////////////////////////////////////////////
    // readLinesIterWith                                                       //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadLinesIterWithWith01(): Bool \ IO = region rc {
        let iter = readLinesIterWith(rc, {charSet = "utf8"}, "./test-resources/file.txt");
        match Iterator.next(iter) {
            case Some(Ok(_)) => true
            case _           => false
        }
    }

    /////////////////////////////////////////////////////////////////////////////
    // readBytes                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadBytes01(): Bool \ IO = region rc {
        Result.isOk(readBytes(rc, "./test-resources/file.txt"))
    }

    /////////////////////////////////////////////////////////////////////////////
    // readBytesWith                                                           //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadBytesWith01(): Bool \ IO = region rc {
        Result.isOk(readBytesWith(rc, {offset = 2i64, count = 2}, "./test-resources/file.txt"))
    }

    @test
    def testReadBytesWith02(): Bool \ IO = region rc {
        match readBytesWith(rc, {offset = 2i64, count = 2}, "./test-resources/file.txt") {
            case Ok(v) => Array.length(v) == 2
            case _     => false
        }
    }

    @test
    def testReadBytesWith03(): Bool \ IO = region rc {
        match readBytesWith(rc, {offset = 10i64, count = 4}, "./test-resources/file.txt") {
            case Ok(v) => v `Array.sameElements` Array#{102i8, 105i8, 108i8, 101i8} @ rc
            case _     => false
        }
    }

    @test
    def testReadBytesWith04(): Bool \ IO = region rc {
        match readBytesWith(rc, {offset = 0i64, count = 0}, "./test-resources/file.txt") {
            case Ok(v) => v `Array.sameElements` Array#{} @ rc
            case _     => false
        }
    }

    @test
    def testReadBytesWith05(): Bool \ IO = region rc {
        match readBytesWith(rc, {offset = -10i64, count = 0}, "./test-resources/file.txt") {
            case Ok(v) => v `Array.sameElements` Array#{} @ rc
            case _     => false
        }
    }

    @test
    def testReadBytesWith06(): Bool \ IO = region rc {
        Result.isErr(readBytesWith(rc, {offset = 0i64, count = -10}, "./test-resources/file.txt"))
    }

    @test
    def testReadBytesWith07(): Bool \ IO = region rc {
        Result.isErr(readBytesWith(rc, {offset = -10i64, count = 10}, "./test-resources/file.txt"))
    }

    /////////////////////////////////////////////////////////////////////////////
    // readChunks                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testReadChunks01(): Bool \ IO = region rc {
        let iter = readChunks(rc, 2, "./test-resources/file.txt");
        match Iterator.next(iter) {
            case Some(Ok(_)) => true
            case _           => false
        }
    }

    @test
    def testReadChunks02(): Bool \ IO = region rc {
        let iter = readChunks(rc, 2, "./test-resources/file.txt");
        discard  Iterator.next(iter);
        match Iterator.next(iter) {
            case Some(Ok(_)) => true
            case _           => false
        }
    }

    @test
    def testReadChunks03(): Bool \ IO = region rc {
        let iter = readChunks(rc, 0, "./test-resources/file.txt");
        match Iterator.next(iter) {
            case Some(Err(_)) => true
            case _            => false
        }
    }

    @test
    def testReadChunks04(): Bool \ IO = region rc {
        let iter = readChunks(rc, -10, "./test-resources/file.txt");
        match Iterator.next(iter) {
            case Some(Err(_)) => true
            case _            => false
        }
    }

}