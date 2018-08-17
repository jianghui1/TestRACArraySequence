//
//  TestRACArraySequenceTests.m
//  TestRACArraySequenceTests
//
//  Created by ys on 2018/8/16.
//  Copyright © 2018年 ys. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <ReactiveCocoa.h>
#import <RACArraySequence.h>

@interface TestRACArraySequenceTests : XCTestCase

@end

@implementation TestRACArraySequenceTests

- (void)test_sequenceWithArray
{
    NSArray *array = [NSArray arrayWithObjects:@1, @3, @5, nil];
    RACArraySequence *sequence1 = [RACArraySequence sequenceWithArray:array offset:0];
    RACArraySequence *sequence2 = [RACArraySequence sequenceWithArray:array offset:1];
    
    NSLog(@"sequenceWithArray -- %@ -- %@", sequence1, sequence2);
    
    // 打印日志：
    /*
     2018-08-16 17:31:04.609993+0800 TestRACArraySequence[17036:17045287] sequenceWithArray -- <RACArraySequence: 0x6040002209a0>{ name = , array = (
     1,
     3,
     5
     ) } -- <RACArraySequence: 0x600000231f80>{ name = , array = (
     1,
     3,
     5
     ) }
     */
}

- (void)test_head
{
    NSArray *array = [NSArray arrayWithObjects:@1, @3, @5, nil];
    RACArraySequence *sequence1 = [RACArraySequence sequenceWithArray:array offset:0];
    RACArraySequence *sequence2 = [RACArraySequence sequenceWithArray:array offset:1];
    
    NSLog(@"head -- %@ -- %@", sequence1.head, sequence2.head);
    
    // 打印日志：
    /*
     2018-08-16 17:32:32.562312+0800 TestRACArraySequence[17126:17049484] head -- 1 -- 3
     */
}

- (void)test_tail
{
    NSArray *array = [NSArray arrayWithObjects:@1, @3, @5, nil];
    RACArraySequence *sequence1 = [RACArraySequence sequenceWithArray:array offset:0];
    RACArraySequence *sequence2 = [RACArraySequence sequenceWithArray:array offset:1];
    
    NSLog(@"tail -- %@ -- %@", sequence1.tail, sequence2.tail);
    
    // 打印日志：
    /*
     2018-08-16 17:34:22.513110+0800 TestRACArraySequence[17213:17054829] tail -- <RACArraySequence: 0x600000428840>{ name = , array = (
     1,
     3,
     5
     ) } -- <RACArraySequence: 0x600000428860>{ name = , array = (
     1,
     3,
     5
     ) }
     */
}

- (void)test_array
{
    NSArray *array = [NSArray arrayWithObjects:@1, @3, @5, nil];
    RACArraySequence *sequence1 = [RACArraySequence sequenceWithArray:array offset:0];
    RACArraySequence *sequence2 = [RACArraySequence sequenceWithArray:array offset:1];
    
    NSLog(@"array -- %@ -- %@", sequence1.array, sequence2.array);
    
    // 打印日志：
    /*
     2018-08-16 17:36:17.760576+0800 TestRACArraySequence[17305:17061060] array -- (
     1,
     3,
     5
     ) -- (
     3,
     5
     )
     */
}

- (void)test_concat
{
    NSArray *array = [NSArray arrayWithObjects:@1, @3, @5, nil];
    RACArraySequence *sequence1 = [RACArraySequence sequenceWithArray:array offset:0];
    RACArraySequence *sequence2 = [RACArraySequence sequenceWithArray:array offset:1];
    RACSequence *sequence = [sequence1 concat:sequence2];
    NSLog(@"concat -- %@", sequence);
    NSLog(@"concat -- %@", sequence.head);
    NSLog(@"concat -- %@", sequence.tail.head);
    NSLog(@"concat -- %@", sequence.tail.tail.head);
    NSLog(@"concat -- %@", sequence.tail.tail.tail.head);
    NSLog(@"concat -- %@", sequence.tail.tail.tail.tail.head);
    NSLog(@"concat -- %@", sequence.tail.tail.tail.tail.tail.head);
    NSLog(@"concat -- %@", sequence.tail.tail.tail.tail.tail.tail.head);
    NSLog(@"concat -- %@", sequence.tail.tail.tail.tail.tail.tail.tail.head);
    NSLog(@"concat -- %@", sequence.tail.tail.tail.tail.tail.tail.tail.tail.head);
    
    // 打印日志：
    /*
     2018-08-16 17:42:58.770341+0800 TestRACArraySequence[17609:17081176] concat -- <RACDynamicSequence: 0x60000008e330>{ name = , head = (unresolved), tail = (unresolved) }
     2018-08-16 17:42:58.771144+0800 TestRACArraySequence[17609:17081176] concat -- 1
     2018-08-16 17:42:58.771588+0800 TestRACArraySequence[17609:17081176] concat -- 3
     2018-08-16 17:42:58.772199+0800 TestRACArraySequence[17609:17081176] concat -- 5
     2018-08-16 17:42:58.772522+0800 TestRACArraySequence[17609:17081176] concat -- 3
     2018-08-16 17:42:58.772885+0800 TestRACArraySequence[17609:17081176] concat -- 5
     2018-08-16 17:42:58.773374+0800 TestRACArraySequence[17609:17081176] concat -- (null)
     2018-08-16 17:42:58.773797+0800 TestRACArraySequence[17609:17081176] concat -- (null)
     2018-08-16 17:42:58.774205+0800 TestRACArraySequence[17609:17081176] concat -- (null)
     2018-08-16 17:42:58.776074+0800 TestRACArraySequence[17609:17081176] concat -- (null)
     */
}

@end
