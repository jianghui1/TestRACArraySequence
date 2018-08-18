##### `RACArraySequence`作为`RACSequence`的子类，提供一个额外的方法，同样的，还是进入`.m`中分析。

完整测试用例[在这里](https://github.com/jianghui1/TestRACArraySequence)。

***

    + (instancetype)sequenceWithArray:(NSArray *)array offset:(NSUInteger)offset {
    	NSCParameterAssert(offset <= array.count);
    
    	if (offset == array.count) return self.empty;
    
    	RACArraySequence *seq = [[self alloc] init];
    	seq->_backingArray = [array copy];
    	seq->_offset = offset;
    	return seq;
    }
初始化方法，根据参数的个数决定返回空序列还是array序列。如果返回array序列，保存参数值`array` `offset`。

测试用例：

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
***

    - (id)head {
    	return self.backingArray[self.offset];
    }
根据偏移量`offset`取出`backingArray`中的值返回。

测试用例：

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
***
    - (RACSequence *)tail {
    	RACSequence *sequence = [self.class sequenceWithArray:self.backingArray offset:self.offset + 1];
    	sequence.name = self.name;
    	return sequence;
    }
以`backingArray` `offset+1`为参数调用初始化方法返回一个序列。其实这个序列与原序列的差别就是偏移量`offset`不一样。

测试用例：

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
***

    - (NSArray *)array {
    	return [self.backingArray subarrayWithRange:NSMakeRange(self.offset, self.backingArray.count - self.offset)];
    }
重写父类的方法，获取`backingArray`中从`offset`开始的数据。

测试用例：

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
***
其他方法关于 遍历、序列化、格式化日志，不再分析。

##### 综上，这个类相当于是一个数组，只是根据偏移量`offset`来决定序列值都有哪些。

在`RACSequence`中的`concat:`方法调用了这个类，这里重新分析一下：

    - (instancetype)concat:(RACStream *)stream {
    	NSCParameterAssert(stream != nil);
    
    	return [[[RACArraySequence sequenceWithArray:@[ self, stream ] offset:0]
    		flatten]
    		setNameWithFormat:@"[%@] -concat: %@", self.name, stream];
    }
其实该方法就是将`self` `stream`放到数组中并作为参数生成一个`RACArraySequence`对象，然后通过`flatten`方法将`self`的值与`stream`的值连接成一组值作为新序列的所有值。

测试用例：

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
