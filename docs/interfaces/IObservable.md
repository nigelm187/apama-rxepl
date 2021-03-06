# <a name="iobservable"></a>com.industry.rx_epl.IObservable [<>](/src/rx/interfaces/IObservable.mon)

IObservable is the interface returned by almost all RxEPL operators, this allows the operators to be chained in with a fluent syntax.

```javascript
Observable.fromValues([1,2,3,4)
	.map(Lambda.function1("x => x * 10"))
	.sum()
	.subscribe(Subscriber.create().onNext(logValue));
```

## Operators and Methods
* [Transforms](#transforms)
	* [Map](#map)
	* [FlatMap](#flatmap)
	* [Pluck](#pluck)
	* [Scan](#scan)/[ScanWithInitial](#scanwithinitial)
	* [GroupBy](#groupby)/[GroupByField](#groupbyfield)
	* [GroupByWindow](#groupbywindow)/[WindowTime](#windowtime)/[WindowCount](#windowcount)/[WindowTimeOrCount](#windowtimeorcount)
	* [Buffer](#buffer)/[BufferTime](#buffertime)/[BufferCount](#buffercount)/[BufferCountSkip](#buffercountskip)/[BufferTimeOrCount](#buffertimeorcount)/[Pairwise](#pairwise)
	* [Sort](#sort)/[SortAsc](#sortasc)/[SortDesc](#sortdesc)
	* [ToSortedList](#tosortedlist)/[ToSortedListAsc](#tosortedlistasc)/[ToSortedListDesc](tosorteddesclist)
* [Filters](#filters)
	* [Filter](#filter)
	* [Distinct](#distinct)/[DistinctUntilChanged](#distinctuntilchanged)/[DistinctBy](#distinctby)/[DistinctByUntilChanged](#distinctbyuntilchanged)/[DistinctByField](#distinctbyfield)/[DistinctByFieldUntilChanged](#distinctbyfielduntilchanged)
	* [Take](#take)/[First](#first)/[TakeLast](#takelast)/[Last](#last)
	* [Skip](#skip)/[SkipLast](#skiplast)
	* [TakeUntil](#takeuntil)/[TakeWhile](#takewhile)
	* [SkipUntil](#skipuntil)/[SkipWhile](#skipwhile)
	* [Debounce](#debounce)/[ThrottleFirst](#throttlefirst)/[ThrottleLast](#throttlelast)
	* [Sample](#sample)/[SampleTime](#sampletime)/[SampleCount](#samplecount)/[SampleTimeOrCount](sampletimeorcount)
	* [ElementAt](#elementat)
* [Combiners](#combiners)
	* [Merge](#merge)/[MergeAll](#mergeall)
	* [WithLatestFrom](#withlatestfrom)/[WithLatestFromToSequence](#withlatestfromtosequence)
	* [CombineLatest](#combinelatest)/[CombineLatestToSequence](#combinelatesttosequence)
	* [Zip](#zip)/[ZipToSequence](#ziptosequence)
	* [Concat](#concat)/[ConcatAll](#concatall)/[StartWith](#startwith)
	* [SwitchMap](#switchmap)/[SwitchOnNext](#switchonnext)
* [Error Handling](#error-handling)
	* [CatchError](#catcherror)
	* [Retry](#retry)
* [Utils](#utils)
	* [Subscribe](#subscribe)/[SubscribeOn](#subscribeon)/[SubscribeOnNew](#subscribeonnew)
	* [Do](#do)
	* [Delay](#delay)/[Async](#async)
	* [ObserveOn](#observeon)/[ObserveOnNew](#observeonnew)
	* [ToChannel](#tochannel)/[ToStream](#tostream)
	* [Timestamp](#timestamp)/[UpdateTimestamp](#updatetimestamp)
	* [TimeInterval](#timeinterval)
	* [Pausable](#pausable)/[PausableBuffered](#pausablebuffered)
	* [Let](#let)/[Pipe](#pipe)/[PipeOn](#pipeon)/[PipeOnNew](#pipeonnew)
	* [ComplexPipe](#complexpipe)/[ComplexPipeOn](#complexpipeon)/[ComplexPipeOnNew](#complexpipeonnew)
	* [Decouple](#decouple)
	* [GetSync](#getsync)/[GetSyncOr](#getsyncor)
	* [Repeat](#repeat)
	* [Publish](#publish)/[PublishReplay](#publishreplay)
	* [Connect](#connect)/[RefCount](#refcount)
	* [Share](#share)/[ShareReplay](#sharereplay)
	* [ObserveToChannel](#observetochannel)
	* [IgnoreElements](#ignoreelements)
* [Conditional](#conditional)
	* [Contains](#contains)/[Every](#every)
	* [SequenceEqual](#sequenceequal)
	* [IsEmpty](#isempty)
	* [Amb](#amb)/[Race](#race)
	* [DefaultIfEmpty](#defaultifempty)/[SwitchIfEmpty](#switchifempty)
* [Math and Aggregation](#math-and-aggregation)
	* [Reduce](#reduce)/[ReduceWithInitial](#reducewithinitial)
	* [Count](#count)
	* [Sum](#sum)/[SumInteger](#suminteger)/[SumFloat](#sumfloat)/[SumDecimal](#sumdecimal)
	* [ConcatString](#concatstring)
	* [Max](#max)/[MaxInteger](#maxinteger)/[MaxFloat](#maxfloat)/[MaxDecimal](#maxdecimal)
	* [Min](#min)/[MinInteger](#mininteger)/[MinFloat](#minfloat)/[MinDecimal](#mindecimal)
	* [Average](#average)/[AverageDecimal](#averagedecimal)

### Transforms
<a name="map" href="#map">#</a> .**map**(*action<`value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Map.mon  "Source")

Apply a function to each `value` and pass on the result.
```javascript
action multiplyBy10(integer value) returns integer {
	return value * 10;
}

Observable.fromValues([1,2,3])
	.map(multiplyBy10)
	...
	
// Output: 10, 20, 30
```
See also [FlatMap](#flatmap).

<a name="flatmap" href="#flatmap">#</a> .**flatMap**(*action<`value:` [T1](/docs/README.md#wildcard-class-notation)> returns (sequence<[T2](/docs/README.md#wildcard-class-notation)> | [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> | [ISubject](ISubject.md#isubject)<[T2](/docs/README.md#wildcard-class-notation)>)*) returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/FlatMap.mon  "Source")

Apply a mapping to each `value` that results in multiple values (or an Observable containing 1 or more values) and merge each item in the result into the output.
```javascript
action valueAndPlus1(integer value) returns sequence<integer> {
	return [value, value + 1];
}

Observable.fromValues([1,3,5])
	.flatMap(valueAndPlus1)
	...

// Output: 1, 2, 3, 4, 5, 6
```

See also: [Map](#map).

<a name="pluck" href="#pluck">#</a> .**pluck**(*`fieldName:` any*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Pluck.mon  "Source")

Select a particular field from the incoming value.

Note: The `fieldName` can be of any type (Eg. an integer for [IObservable](#iobservable)\<sequence> or the key type for an [IObservable](#iobservable)\<dictionary>)
```javascript
event E {
	integer value;
}

Observable.fromValues([E(1), E(2), E(3), E(4)])
	.pluck("value")
	...

// Output: 1,2,3,4
```

<a name="scan" href="#scan">#</a> .**scan**(*action<`aggregate:` [T2](/docs/README.md#wildcard-class-notation), `value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Scan.mon  "Source")

Aggregate the data and emit the aggregated value for every incoming event.

Note: The first value is emitted without aggregation
```javascript
action sum(integer currentSum, integer value) returns integer {
	return currentSum + value;
}

Observable.fromValues([1,2,3])
	.scan(sum)
	...

// Output: 1, 3, 6
```
See also: [ScanWithInitial](#scanwithinitial), [Reduce](#reduce)

<a name="scanwithinitial" href="#scanwithinitial">#</a> .**scanWithInitial**(*action<`aggregate:` [T2](/docs/README.md#wildcard-class-notation), `value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation), `initialValue:` [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Scan.mon  "Source")

Aggregate the data and emit the aggregated value for every incoming event. The initial value for the aggregation is supplied.
```javascript
action sum(integer currentSum, integer value) returns integer {
	return currentSum + value;
}

Observable.fromValues([1,2,3])
	.scanWithInitial(sum, 5)
	...

// Output: 6, 8, 11
```
See also: [Scan](#scan), [ReduceWithInitial](#reducewithinitial)

<a name="groupby" href="#groupby">#</a> .**groupBy**(*action<`value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[IObservable](#iobservable)<[T1](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/GroupBy.mon  "Source")

Group the data into separate observables based on a calculated group identifier. These observables are sent on the resulting [IObservable](#iobservable). The provided action takes a value and returns a group identifier.
```javascript
event Fruit {
	string type;
	integer value;
}

action groupId(Fruit fruit) returns string {
	return fruit.type;
}

action sumValuesInGroup(IObservable group) returns IObservable {
	return group
		.reduceWithInitial(Lambda.function2("groupResult, fruit => [fruit.type, groupResult[1] + fruit.value]"), ["", 0]);
}

Observable.fromValues([Fruit("apple", 1), Fruit("banana", 2), Fruit("apple", 3)])
	.groupBy(groupId)
	.flatMap(sumValuesInGroup)
	...

// Output: ["banana", 2], ["apple", 4]
```
See also: [GroupByField](#groupbyfield), [GroupByWindow](#groupbywindow)

<a name="groupbyfield" href="#groupbyfield">#</a> .**groupByField**(*`fieldName:` [any](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/GroupBy.mon  "Source")

Group the data into separate observables based on a key field. These observables are sent on the resulting [IObservable](#iobservable).

Note: The `fieldName` can be of any type (Eg. an integer for [IObservable](#iobservable)\<sequence> or the key type for an [IObservable](#iobservable)\<dictionary>)

```javascript
event Fruit {
	string type;
	integer value;
}

action sumValuesInGroup(IObservable group) returns IObservable {
	return group
		.reduceWithInitial(Lambda.function2("groupResult, fruit => [fruit.type, groupResult[1] + fruit.value]"), ["", 0]);
}

Observable.fromValues([Fruit("apple", 1), Fruit("banana", 2), Fruit("apple", 3)])
	.groupByField("type")
	.flatMap(sumValuesInGroup)
	...

// Output: ["banana", 2], ["apple", 4]
```
See also: [GroupBy](#groupby), [GroupByWindow](#groupbywindow)

<a name="groupbywindow" href="#groupbywindow">#</a> .**groupByWindow**(*`trigger:` [IObservable](#iobservable)*) returns [IObservable](#iobservable)<[IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/Window.mon  "Source")

Partition each value into the current observable window. The observable windows are sent on the resulting [IObservable](#iobservable). The provided `trigger` determines when a new window is created.

Note: The current window is completed when a new window is created.

```javascript
action source(IResolver r) {
	listener l := on all wait(0.25) {
		r.next(1);
	}
	r.onUnsubscribe(l.quit);
}

action sumValuesInWindow(IObservable group) returns IObservable {
	return group.sumInteger();
}

Observable.create(source)
	.groupByWindow(Observable.interval(1.0))
	.flatMap(sumValuesInWindow)
	...

// Output: 3, 4, 4...
```
See also: [Buffer](#buffer), [GroupBy](#groupby)

<a name="windowtime" href="#windowtime">#</a> .**windowTime**(*`seconds:` float*) returns [IObservable](#iobservable)<[IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/Window.mon  "Source")

Partition each value into the current observable window. The observable windows are sent on the resulting [IObservable](#iobservable). A new window is created every t seconds (starting when the subscription begins).

Note: The current window is completed when a new window is created.

```javascript
action source(IResolver r) {
	listener l := on all wait(0.25) {
		r.next(1);
	}
	r.onUnsubscribe(l.quit);
}

action sumValuesInWindow(IObservable group) returns IObservable {
	return group.sumInteger();
}

Observable.create(source)
	.windowTime(1.0)
	.flatMap(sumValuesInWindow)
	...

// Output: 3, 4, 4...
```
See also: [BufferTime](#buffertime), [GroupBy](#groupby)

<a name="windowcount" href="#windowcount">#</a> .**windowCount**(*`count:` integer*) returns [IObservable](#iobservable)<[IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/Window.mon  "Source")

Partition each value into the current observable window. The observable windows are sent on the resulting [IObservable](#iobservable). A new window is created after every n values.

Note: The current window is completed when a new window is created.

```javascript
action sumValuesInWindow(IObservable group) returns IObservable {
	return group.sumInteger();
}

Observable.fromValues([1,2,3,4,5,6])
	.windowCount(2)
	.flatMap(sumValuesInWindow)
	...

// Output: 3, 7, 11
```
See also: [BufferCount](#buffercount), [GroupBy](#groupby)

<a name="windowtimeorcount" href="#windowtimeorcount">#</a> .**windowTimeOrCount**(*`seconds:` float, `count:` integer*) returns [IObservable](#iobservable)<[IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/Window.mon  "Source")

Partition each value into the current observable window. The observable windows are sent on the resulting [IObservable](#iobservable). A new window is created after every t seconds or n values (whichever comes first).

Note: The current window is completed when a new window is created.

See also: [BufferTimeOrCount](#buffertimeorcount), [GroupBy](#groupby)

<a name="buffer" href="#buffer">#</a> .**buffer**(*`trigger:` [IObservable](#iobservable)*) returns [IObservable](#iobservable)<sequence\<any>> [<>](/src/rx/operators/Buffer.mon  "Source")

Store each value in the current bucket, emitting the bucket (as a sequence\<any>) when the trigger fires.

Note: The final bucket will be emitted on completion of the source. Unsubscribing will not trigger emission of the the current bucket.
```javascript
Observable.interval(0.25) // Emits an incrementing integer every 250 millis
	.buffer(Observable.interval(1.0))
	...

// Output: [0,1,2,3], [4,5,6,7], [8,9,10,11]...
```
See also: [GroupByWindow](#groupbywindow), [GroupBy](#groupby)

<a name="buffertime" href="#buffertime">#</a> .**bufferTime**(*`seconds:` float*) returns [IObservable](#iobservable)<sequence\<any>> [<>](/src/rx/operators/BufferTime.mon  "Source")

Store each value in the current bucket, emitting the bucket (as a sequence\<any>) every t seconds.

Note: The final bucket will be emitted on completion of the source. Unsubscribing will not trigger emission of the the current bucket.
```javascript
Observable.interval(0.25) // Emits an incrementing integer every 250 millis
	.bufferTime(1.0)
	...

// Output: [0,1,2,3], [4,5,6,7], [8,9,10,11]...
```
See also: [WindowTime](#windowtime), [GroupBy](#groupby)

<a name="buffercount" href="#buffercount">#</a> .**bufferCount**(*`count:` integer*) returns [IObservable](#iobservable)<sequence\<any>> [<>](/src/rx/operators/Buffer.mon  "Source")

Store each value in the current bucket, emitting the bucket (as a sequence\<any>) every n values.

Note: The final bucket will be emitted on completion of the source. Unsubscribing will not trigger emission of the the current bucket.
```javascript
Observable.fromValues([1,2,3,4,5,6])
	.bufferCount(2)
	...

// Output: [1,2], [3,4], [5,6]
```
See also: [WindowCount](#windowcount), [BufferCountSkip](#buffercountskip), [Pairwise](#pairwise)

<a name="buffercountskip" href="#buffercountskip">#</a> .**bufferCountSkip**(*`count:` integer, `skip:` integer*) returns [IObservable](#iobservable)<sequence\<any>> [<>](/src/rx/operators/Buffer.mon  "Source")

Store each value in the current bucket, emitting the bucket (as a sequence\<any>) every `count` values. The bucket 'slides' such that, after filling for the first time, it emits every `skip` values with the last `count` items.

Note: The final bucket and all partial buckets (caused by the sliding) will be emitted on completion. Unsubscribing will not trigger emission of the the current bucket.

Note 2: The skip value can be greater than the count, this will cause a gap between buckets.

```javascript
Observable.fromValues([1,2,3,4,5,6])
	.bufferCountSkip(3,1)
	...

// Output: [1,2,3], [2,3,4], [3,4,5], [4,5,6], [5,6], [6]
```
See also: [BufferCount](#buffercount), [Pairwise](#pairwise)

<a name="buffertimeorcount" href="#buffertimeorcount">#</a> .**bufferTimeOrCount**(*`seconds:` float, `count:` integer*) returns [IObservable](#iobservable)<sequence\<any>> [<>](/src/rx/operators/Buffer.mon  "Source")

Store each value in the current bucket, emitting the bucket (as a sequence\<any>) every `count` values or when the time `seconds` has elapsed (Whichever comes first).

Note: The final bucket will be emitted on completion of the source. Unsubscribing will not trigger emission of the the current bucket.

See also: [BufferCount](#buffercount), [BufferCountSkip](#buffercountskip)

<a name="pairwise" href="#pairwise">#</a> .**pairwise**() returns [IObservable](#iobservable)<sequence\<any>> [<>](/src/rx/operators/Buffer.mon  "Source")

Emit every value and the previous value in a sequence\<any>.

Note: If only 1 value is received then no values are emitted.

```javascript
Observable.fromValues([1,2,3,4,5,6])
	.pairwise()
	...

// Output: [1,2], [2,3], [3,4], [4,5], [5,6]
```

See also: [BufferCount](#buffercount), [BufferCountSkip](#buffercountskip)

<a name="sort" href="#sort">#</a> .**sort**(*`comparator:` action<`left:` [T](/docs/README.md#wildcard-class-notation), `right:` [T](/docs/README.md#wildcard-class-notation)> returns number*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ToSortedList.mon  "Source")

Sort the values by a comparator. The comparator takes 2 values from the observable and should produce a number to indicate which one is larger. 

A positive number indicates that the `right` value should be later in the output, whereas a negative number indicates the `left` value. 

Note: Uses the heapsort algorithm - there's no guaranteed ordering for equal values.
```javascript
action comparator(integer left, integer right) returns integer {
	return right - left;
}

Observable.fromValues([4,1,3,2])
	.sort(comparator)
	...

// Output: 1,2,3,4
```

<a name="sortasc" href="#sortasc">#</a> .**sortAsc**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ToSortedList.mon  "Source")

Sort the values by the standard `>` or `<` comparator. Numbers with different types will be coerced to to same type before comparison.

Note: Uses the heapsort algorithm - there's no guaranteed ordering for equal values
```javascript
Observable.fromValues([4,1,3,2])
	.sortAsc()
	...

// Output: 1,2,3,4
```

<a name="sortdesc" href="#sortdesc">#</a> .**sortDesc**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ToSortedList.mon  "Source")

Sort the values by the standard `>` or `<` comparator. Numbers with different types will be coerced to to same type before comparison.

Note: Uses the heapsort algorithm - there's no guaranteed ordering for equal values
```javascript
Observable.fromValues([4,1,3,2])
	.sortDesc()
	...

// Output: 4,3,2,1
```
<a name="tosortedlist" href="#tosortedlist">#</a> .**toSortedList**(*`comparator:` action<`left:` [T](/docs/README.md#wildcard-class-notation), `right:` [T](/docs/README.md#wildcard-class-notation)> returns number*) returns [IObservable](#iobservable)<sequence<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/ToSortedList.mon  "Source")

Sort the values by a comparator. The comparator takes 2 values from the observable and should produce a number to indicate which one is larger. The sorted values are output as a sequence\<any>.

A positive number indicates that the `right` value should be later in the output, whereas a negative number indicates the `left` value. 

Note: Uses the heapsort algorithm - there's no guaranteed ordering for equal values.
```javascript
action comparator(integer left, integer right) returns integer {
	return right - left;
}

Observable.fromValues([4,1,3,2])
	.toSortedList(comparator)
	...

// Output: [1,2,3,4]
```

<a name="tosortedlistasc" href="#tosortedlistasc">#</a> .**toSortedListAsc**() returns [IObservable](#iobservable)<sequence<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/ToSortedList.mon  "Source")

Sort the values by the standard `>` or `<` comparator. Numbers with different types will be coerced to to same type before comparison. The sorted values are output as a sequence\<any>.

Note: Uses the heapsort algorithm - there's no guaranteed ordering for equal values
```javascript
Observable.fromValues([4,1,3,2])
	.toSortedListAsc()
	...

// Output: [1,2,3,4]
```
<a name="tosortedlistdesc" href="#tosortedlistdesc">#</a> .**toSortedListDesc**() returns [IObservable](#iobservable)<sequence<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/ToSortedList.mon  "Source")

Sort the values by the standard `>` or `<` comparator. Numbers with different types will be coerced to to same type before comparison. The sorted values are output as a sequence\<any>.

Note: Uses the heapsort algorithm - there's no guaranteed ordering for equal values
```javascript
Observable.fromValues([4,1,3,2])
	.toSortedListDesc()
	...

// Output: [4,3,2,1]
```

### Filters
<a name="filter" href="#filter">#</a> .**filter**(*`predicate:` action<`value:` [T](/docs/README.md#wildcard-class-notation)> returns boolean*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Filter.mon  "Source")

Filter the values by the provided predicate.

```javascript
action greaterThan3(integer value) returns boolean {
	return value > 3;
}

Observable.fromValues([1,2,3,4,5,6])
	.filter(greaterThan3)
	...

// Output: 4, 5, 6
```

<a name="distinct" href="#distinct">#</a> .**distinct**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Distinct.mon  "Source")

Remove all duplicate values.

Note: This requires storing every unique value and therefore care should be taken when used on long running observables. A safer alternative is [DistinctUntilChanged](#distinctuntilchanged)

```javascript
Observable.fromValues([1,2,1,2,3,2,3])
	.distinct()
	...

// Output: 1, 2, 3
```

See also: [DistinctUntilChanged](#distinctuntilchanged)

<a name="distinctuntilchanged" href="#distinctuntilchanged">#</a> .**distinctUntilChanged**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Distinct.mon  "Source")

Remove all back-to-back duplicates.

```javascript
Observable.fromValues([1,1,2,2,1,2,3,3])
	.distinctUntil()
	...

// Output: 1, 2, 1, 2, 3
```

See also: [Distinct](#distinct)

<a name="distinctby" href="#distinctby">#</a> .**distinctBy**(*`getKey:` action<`value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[T1](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Distinct.mon  "Source")

Remove all duplicates. 

The `getKey` action returns the value by which to measure uniqueness.

Note: This requires storing every unique value and therefore care should be taken when used on long running observables. A safer alternative is [DistinctByUntilChanged](#distinctbyuntilchanged)

```javascript
action getUniqueKey(integer value) returns integer {
	return value % 3;
}

Observable.fromValues([1,2,3,4,5,6])
	.distinctBy(getUniqueKey)
	...

// Output: 1, 2, 3
```

<a name="distinctbyuntilchanged" href="#distinctbyuntilchanged">#</a> .**distinctByUntilChanged**(*`getKey:` action<`value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[T1](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Distinct.mon  "Source")

Remove all back-to-back duplicates. 

The `getKey` action returns the value by which to measure uniqueness.
```javascript
action getUniqueKey(integer value) returns integer {
	return value % 3;
}

Observable.fromValues([1,1,1,4,4,4,5,6,7,8])
	.distinctBy(getUniqueKey)
	...

// Output: 1,5,6,7,8
```

<a name="distinctbyfield" href="#distinctbyfield">#</a> .**distinctByField**(*`fieldName:` any*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Distinct.mon  "Source")

Remove values with a duplicate `fieldName` value. 

Note: This requires storing every unique value and therefore care should be taken when used on long running observables. A safer alternative is [DistinctByFieldUntilChanged](#distinctbyfielduntilchanged)


Note: The `fieldName` can be of any type (Eg. an integer for [IObservable](#iobservable)\<sequence> or the key type for an [IObservable](#iobservable)\<dictionary>)
```javascript
event E {
	integer value;
}

Observable.fromValues([E(1),E(2),E(1),E(2),E(3)])
	.distinctByField("value")
	...

// Output: E(1), E(2), E(3)
```

<a name="distinctbyfielduntilchanged" href="#distinctbyfielduntilchanged">#</a> .**distinctByFieldUntilChanged**(*`fieldName:` any*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Distinct.mon  "Source")

Remove back-to-back values with a duplicate `fieldName` value. 

Note: The `fieldName` can be of any type (Eg. an integer for [IObservable](#iobservable)\<sequence> or the key type for an [IObservable](#iobservable)\<dictionary>)
```javascript
event E {
	integer value;
}

Observable.fromValues([E(1),E(1),E(2),E(1),E(3)])
	.distinctByFieldUntilChanged("value")
	...

// Output: E(1), E(2), E(1), E(3)
```

<a name="take" href="#take">#</a> .**take**(*`count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Take.mon  "Source")

Take only the first `count` items.

```javascript
Observable.fromValues([1,2,3,4])
	.take(3)
	...

// Output: 1,2,3
```

<a name="first" href="#first">#</a> .**first**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/First.mon  "Source")

Take only the first item.

```javascript
Observable.fromValues([1,2,3,4])
	.first()
	...

// Output: 1
```

<a name="takelast" href="#takelast">#</a> .**takeLast**(*`count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/TakeLast.mon  "Source")

Take only the last `count` items.

Note: The Observable must complete otherwise you won't receive a value.
```javascript
Observable.fromValues([1,2,3,4])
	.takeLast(3)
	...

// Output: 2,3,4
```

<a name="last" href="#last">#</a> .**last**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Last.mon  "Source")

Take only the last item.

Note: The Observable must complete otherwise you won't receive a value.
```javascript
Observable.fromValues([1,2,3,4])
	.last()
	...

// Output: 4
```

<a name="skip" href="#skip">#</a> .**skip**(*`count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Skip.mon  "Source")

Skip the first `count` values.

```javascript
Observable.fromValues([1,2,3,4])
	.skip(2)
	...

// Output: 3,4
```

<a name="skiplast" href="#skiplast">#</a> .**skipLast**(*`count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/SkipLast.mon  "Source")

Skip the last `count` values.

```javascript
Observable.fromValues([1,2,3,4])
	.skipLast(2)
	...

// Output: 1,2
```

<a name="takeuntil" href="#takeuntil">#</a> .**takeUntil**(*`trigger:` [IObservable](#iobservable)*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/TakeUntil.mon  "Source")

Take values until the `trigger` receives a value.
```javascript
Observable.interval(0.1) // Emits an incrementing integer every 100 millis
	.takeUntil(Observable.interval(1.0))
	...

// Output: 0,1,2,3,4,5,6,7,8,9
```

<a name="takewhile" href="#takewhile">#</a> .**takeWhile**(*`predicate:` action<`value:` [T](/docs/README.md#wildcard-class-notation)> returns boolean*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/TakeWhile.mon  "Source")

Take until the `predicate` for a received `value` returns false.
```javascript
action isLessThan3(integer value) returns boolean {
	return values < 3;
}

Observable.fromValues([0,1,2,3,4])
	.takeWhile(isLessThan3)
	...

// Output: 0,1,2
```

<a name="skipuntil" href="#skipuntil">#</a> .**skipUntil**(*`trigger:` [IObservable](#iobservable)*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/SkipUntil.mon  "Source")

Skip values until the `trigger` receives a value.
```javascript
Observable.interval(0.1) // Emits an incrementing integer every 100 millis
	.skipUntil(Observable.interval(1.0))
	...

// Output: 10,11,12,13...
```

<a name="skipwhile" href="#skipwhile">#</a> .**skipWhile**(*`predicate:` action<`value:` [T](/docs/README.md#wildcard-class-notation)> returns boolean*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/SkipWhile.mon  "Source")

Skip until the `predicate` for a received `value` returns false.
```javascript
action isLessThan3(integer value) returns boolean {
	return values < 3;
}

Observable.fromValues([0,1,2,3,4])
	.skipWhile(isLessThan3)
	...

// Output: 3,4
```

<a name="debounce" href="#debounce">#</a> .**debounce**(*`seconds:` float*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Debounce.mon  "Source")

Only emit values after there has been a t `seconds` gap between values.

Note: If there is never a t `seconds` gap in the data then a value will not be emitted.

```javascript
action source(IResolver resolver) {
	on wait(0.0) { resolver.next(0); }
	on wait(0.1) { resolver.next(1); }
	on wait(0.2) { resolver.next(2); }
	on wait(1.3) { resolver.next(3); }
	on wait(1.4) { resolver.next(4); }
	on wait(3.0) { resolver.complete(); }
}

Observable.create(source)
	.debounce(1.0)
	...

// Output: 2,4
```

<a name="throttlefirst" href="#throttlefirst">#</a> .**throttleFirst**(*`seconds:` float*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ThrottleFirst.mon  "Source")

When a value arrives emit it but then don't emit any more until t `seconds` have elapsed.

Note: the time windows starts when a value is received, and restarts when a value is received after the time has elapsed.

```javascript
action source(IResolver resolver) {
	on wait(0.0) { resolver.next(0); }
	on wait(0.1) { resolver.next(1); }
	on wait(0.2) { resolver.next(2); }
	on wait(1.3) { resolver.next(3); }
	on wait(1.4) { resolver.next(4); }
	on wait(3.0) { resolver.complete(); }
}

Observable.create(source)
	.throttleFirst(1.0)
	...

// Output: 0, 3
```

<a name="throttlelast" href="#throttlelast">#</a> .**throttleLast**(*`seconds:` float*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ThrottleLast.mon  "Source")

When a value arrives start throttling (without sending a value). After t `seconds` have elapsed emit the last value received in the throttling period.

Note: the time windows starts when a value is received, and restarts when a value is received after the time has elapsed.

```javascript
action source(IResolver resolver) {
	on wait(0.0) { resolver.next(0); }
	on wait(0.1) { resolver.next(1); }
	on wait(0.2) { resolver.next(2); }
	on wait(1.3) { resolver.next(3); }
	on wait(1.4) { resolver.next(4); }
	on wait(3.0) { resolver.complete(); }
}

Observable.create(source)
	.throttleLast(1.0)
	...

// Output: 2, 4
```

<a name="sample" href="#sample">#</a> .**sample**(*`trigger:` [IObservable](#iobservable)*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Sample.mon  "Source")

Take the most recently received value whenever the `trigger` fires.

```javascript
Observable.interval(0.1) // Emits an incrementing integer every 100 millis
	.sample(Observable.interval(1.0))
	...

// Output: 9,19,29
```

<a name="sampletime" href="#sampletime">#</a> .**sampleTime**(*`seconds:` float*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Sample.mon  "Source")

Take the most recently received value every t `seconds`.

```javascript
Observable.interval(0.1) // Emits an incrementing integer every 100 millis
	.sample(1.0)
	...

// Output: 9,19,29
```

<a name="samplecount" href="#samplecount">#</a> .**sampleCount**(*`count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Sample.mon  "Source")

Take only every `count` value.

```javascript
Observable.fromValues([0,1,2,3,4,5])
	.sampleCount(2)
	...

// Output: 1,3,5
```

<a name="sampletimeorcount" href="#sampletimeorcount">#</a> .**sampleTimeOrCount**(*`seconds:` float, `count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Sample.mon  "Source")

Take a value whenever t `seconds` or `count` values have been received (Whichever comes first).

Note: The timer is reset after a value is emitted.

<a name="elementat" href="#elementat">#</a> .**elementAt**(*`index:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ElementAt.mon  "Source")

Take only the n'th `index` element.

```javascript
Observable.fromValues([0,1,2,3])
	.elementAt(2)
	...

// Output: 2
```

### Combiners
<a name="merge" href="#merge">#</a> .**merge**(*`other:` sequence<[IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)>>*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Merge.mon  "Source")

Merge the outputs of all of the provided `other` observables.

```javascript
Observable.interval(0.1)
	.merge([Observable.interval(0.1)])
	...

// Output: 0,0,1,1,2,2,3,3...
```
<a name="mergeall" href="#mergeall">#</a> .**mergeAll**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Merge.mon  "Source")

Removes a layer of nesting from observables. Received values which are  [IObservable](#iobservable)s are merged into the output. Received values which are sequences/dictionaries have their values merged into the output.

```javascript
Observable.fromValues([<any> Observable.interval(0.1), [1,2,3]])
	.mergeAll()
	...

// Output: 1,2,3,0,1,2,3,4...
```

<a name="withlatestfrom" href="#withlatestfrom">#</a> .**withLatestFrom**(*`other:` sequence<[IObservable](#iobservable)\<any>>, `combiner:` action\<`values:` sequence\<any>> returns any*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/WithLatestFrom.mon  "Source")

Every time a value is received, take the latest values from the `other` observables and produce an output by running the `combiner`.

Note: The `combiner` takes the `values` in the same order as the observables are defined (starting with the main source observable).

```javascript
action createSequenceString(sequence<any> values) returns any {
	sequence<string> strings := new sequence<string>;
	any value;
	for value in values {
		strings.append(value.valueToString());
	}
	return "[" + ",".join(strings) + "]";
}

Observable.interval(1.0)
	.withLatestFrom([Observable.interval(0.1)], createSequenceString)
	...

// Output: "[0,9]","[1,19]","[2,29]"...
```

<a name="withlatestfromtosequence" href="#withlatestfromtosequence">#</a> .**withLatestFromToSequence**(*`other:` sequence<[IObservable](#iobservable)\<any>>*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/WithLatestFrom.mon  "Source")

Every time a value is received, take the latest values from the `other` observables and produce a sequence\<any> containing the values from all.

Note: The resulting sequence contains the `values` in the same order as the observables are defined (starting with the main source observable).

```javascript
Observable.interval(1.0)
	.withLatestFrom([Observable.interval(0.1)])
	...

// Output: [0,9], [1,19], [2,29]...
```

<a name="combinelatest" href="#combinelatest">#</a> .**combineLatest**(*`other:` sequence<[IObservable](#iobservable)\<any>>, `combiner:` action\<`values:` sequence\<any>> returns any*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/CombineLatest.mon  "Source")

Every time a value is received, from either the source or the `other` observables, produce an output by running the `combiner`.

Note: The `combiner` takes the `values` in the same order as the observables are defined (starting with the main source observable).

```javascript
action createSequenceString(sequence<any> values) returns any {
	sequence<string> strings := new sequence<string>;
	any value;
	for value in values {
		strings.append(value.valueToString());
	}
	return "[" + ",".join(strings) + "]";
}

Observable.interval(1.0)
	.combineLatest([Observable.interval(0.5)], createSequenceString)
	...

// Output: "[0,0]","[0,1]","[0,2]","[1,2]","[1,3]","[1,4]","[2,4]"...
```

<a name="combinelatesttosequence" href="#combinelatesttosequence">#</a> .**combineLatestToSequence**(*`other:` sequence<[IObservable](#iobservable)\<any>>*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/CombineLatest.mon  "Source")

Every time a value is received, from either the source or the `other` observables, produce a sequence\<any> containing the values from all.

Note: The resulting sequence contains the `values` in the same order as the observables are defined (starting with the main source observable).

```javascript
Observable.interval(1.0)
	.combineLatestToSequence([Observable.interval(0.1)])
	...

// Output: [0,0],[0,1],[0,2],[1,2],[1,3],[1,4],[2,4]...
```

<a name="zip" href="#zip">#</a> .**zip**(*`other:` sequence<[IObservable](#iobservable)\<any>>, `combiner:` action\<`values:` sequence\<any>> returns any*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Zip.mon  "Source")

Combine multiple observables by taking the n'th value from every observable, producing an output by running the `combiner`.

I.e. The first output is the result from the combiner running on the first value from every source.

Note: The `combiner` takes the `values` in the same order as the observables are defined (starting with the main source observable).

Note2: The result is terminated when any of the sources run out of values, but only after the output for those values has been generated.

Note3: This requires storing values until their counterpart in another observable is found, this could be expensive with long running observables.

```javascript
action createSequenceString(sequence<any> values) returns any {
	sequence<string> strings := new sequence<string>;
	any value;
	for value in values {
		strings.append(value.valueToString());
	}
	return "[" + ",".join(strings) + "]";
}

Observable.interval(1.0)
	.zip([Observable.interval(0.5), Observable.fromValues(["a","b","c"])], createSequenceString)
	...

// Output: "[0,0,a]","[1,1,b]","[2,2,c]"
```

<a name="ziptosequence" href="#ziptosequence">#</a> .**zipToSequence**(*`other:` sequence<[IObservable](#iobservable)\<any>>*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Zip.mon  "Source")

Combine multiple observables by taking the n'th value from every observable, producing a sequence\<any> containing all of the n'th values.

I.e. The first output is a sequence\<any> containing the first value from every source.

Note: The output sequence\<any> contains the values in the same order as the observables are defined (starting with the main source observable).

Note2: The result is terminated when any of the sources run out of values, but only after the output for those values has been generated.

Note3: This requires storing values until their counterpart in another observable is found, this could be expensive with long running observables.

```javascript
Observable.interval(1.0)
	.zipToSequence([Observable.interval(0.5), Observable.fromValues(["a","b","c"])])
	...

// Output: [0,0,a],[1,1,b],[2,2,c]
```

<a name="concat" href="#concat">#</a> .**concat**(*`other:` sequence<[IObservable](#iobservable)\<any>>*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Concat.mon  "Source")

After the current observable completes, instead of completing, connect to the next source observable. This repeats until all sources have completed.

Note: This will potentially miss values if the `other` observables are "hot" (Miss values when not connected. Eg. Values from a channel or stream).

```javascript
Observable.fromValues([1,2,3])
	.concat([Observable.fromValues([4,5,6])])
	...

// Output: 1,2,3,4,5,6
```

See also: [Repeat](#repeat)

<a name="concatall" href="#concatall">#</a> .**concatAll**() returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Concat.mon  "Source")

For a source that provides IObservables (or sequences) it will concatenate the contents. The next IObservable will be connected to after the previous one completes.

Note: This will potentially miss values if the subsequent observables are "hot" (Miss values when not connected. Eg. Values from a channel or stream).

```javascript
Observable.fromValues([
		Observable.range([1,5]).delay(3.0),
		Observable.fromValues([6,7,8])
	])
	.concatAll()
	...

// Output: 1,2,3,4,5,6,7,8
```

See also: [MergeAll](#mergeall)

<a name="startwith" href="#startwith">#</a> .**startWith**(*`startingValues:` sequence\<any>*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/StartWith.mon  "Source")

Start the current observable with the values provided.

```javascript
Observable.fromValues([1,2,3])
	.startWith([<any>4,5,6])
	...

// Output: 4,5,6,1,2,3
```

<a name="switchmap" href="#switchmap">#</a> .**switchMap**(*`mapper:` action<[T1](/docs/README.md#wildcard-class-notation)> returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)>*) returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/SwitchMap.mon  "Source")

Run a mapping function on every value, the result of which is an [IObservable](#iobservable). This observable will be the source of output values until the next observable is provided by the mapping function.

Note: This will complete after the last produced observable completes.

```javascript
action toRange0ToN(integer n) returns IObservable {
	return Observable.range(0, n);
}

Observable.fromValues([1,2,3,4])
	.switchMap(toRange0ToN)
	...

// Output: 0,1,0,1,2,0,1,2,3,0,1,2,3,4
```

<a name="switchonnext" href="#switchonnext">#</a> .**switchOnNext**() returns [IObservable](#iobservable)\<any> [<>](/src/rx/operators/SwitchMap.mon  "Source")

Takes every provided observable and connects to it until another is received, at which point it switches to the new one.

The source must be an [IObservable](#iobservable)<[IObservable](#iobservable)\<any>>. 

Note: This will complete after the last produced observable completes.

```javascript
Observable.fromValues([Observable.range(0,3), Observable.range(4,6)])
	.switchOnNext()
	...

// Output: 0,1,2,3,4,5,6
```

### Error Handling
<a name="catcherror" href="#catcherror">#</a> .**catchError**(*`substitute:`  [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)>*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/CatchError.mon  "Source")

Switch to an alternative data source in the event of an error.

```javascript
action someActionThatThrows(integer value) returns integer {
	throw com.apama.exceptions.Exception("Ahhhh", "RuntimeException");
}

Observable.fromValues([1,2,3,4])
	.map(someActionThatThrows)
	.catchError(Observable.fromValues(5,6,7,8))
	...

// Output: 5,6,7,8
```

<a name="retry" href="#retry">#</a> .**retry**(*`attempts:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Retry.mon  "Source")

Reconnect to the datasource in the event of an error. At most `attempts` times.

```javascript
action sometimesThrows(integer value) returns integer {
	if (5).rand() = 0 {
		throw com.apama.exceptions.Exception("Ahhhh", "RuntimeException");
	}
	return value;
}

Observable.fromValues([1,2,3,4])
	.map(sometimesThrows)
	.retry(3)
	...

// Example Output: 1,1,2,3,1,2,3,4
// Example Output: 1,1,2,1,2,1, Exception("Ahhhh", "RuntimeException")
```
 
### Utils
<a name="subscribe" href="#subscribe">#</a> .**subscribe**(*[Subscriber](../utilities/Subscriber.md#subscriber)*) returns [ISubscription](ISubscription.md#isubscription) [<>](/src/rx/operators/internals/Subscribe.mon  "Source")

Connect to the source observable, and register listeners for values, errors and completion.

The returned [ISubscription](ISubscription.md#isubscription) can be used to manually terminate the subscription.

```javascript
action logValue(any value) {
	log value.valueToString();
}

action logError(com.apama.exceptions.Exception e) {
	log e.toString();
}

action logComplete() {
	log "Done!";
}

Observable.fromValues([1,2,3])
	.subscribe(Subscriber.create().onNext(logValue).onError(logError).onComplete(logComplete));

// Output: 1,2,3,Done!
```

<a name="subscribeon" href="#subscribeon">#</a> .**subscribeOn**(*[Subscriber](../utilities/Subscriber.md#subscriber),  context*) returns [ISubscription](ISubscription.md#isubscription) [<>](/src/rx/operators/internals/SubscribeOn.mon  "Source")<br/>
<a name="subscribeonnew" href="#subscribeonnew">#</a> .**subscribeOnNew**(*[Subscriber](../utilities/Subscriber.md#subscriber)*) returns [ISubscription](ISubscription.md#isubscription) [<>](/src/rx/operators/internals/SubscribeOn.mon  "Source")

Connect to the source observable on a different context, and register listeners for values, errors and completion.

The returned [ISubscription](ISubscription.md#isubscription) can be used to manually terminate the subscription.

**Important Note:** This will not recommended for complicated observables! Instead create the observable on a spawned context, or use [ObserveOn](#observeon).

```javascript
action logValue(any value) {
	log value.valueToString();
}

action logComplete() {
	log "Done!";
}

Observable.fromValues([1,2,3])
	.subscribeOn(Subscriber.create().onNext(logValue).onComplete(logComplete), context("Context2"));

// Output (on Context2): 1,2,3,Done!
```
**A better alternative:**
```javascript
action createAndRunObservable() {
	ISubscription s := Observable.fromValues([1,2,3])
		.subscribe(Subscriber.create().onNext(logValue).onComplete(logComplete))
}

spawn createAndRunObservable() to context("Context2");
```

<a name="do" href="#do">#</a> .**do**(*[Subscriber](../utilities/Subscriber.md#subscriber)*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Do.mon  "Source")

Snoops the output of an observable (at the point where the do is added), registering listeners for values, errors and completion, without subscribing to the observable.

This is very useful for debugging.

```javascript
action logValue(integer value) {
	log value.toString();
}

action logDone() {
	log "Done!";
}

Observable.fromValues([1,2,3,4])
	.do(Subscriber.create().onNext(logValue).onComplete(logDone))
	...

// Do Output: 1,2,3,4,Done!
// Output: 1,2,3,4
```

See also: [Subscribe](#subscribe)

<a name="delay" href="#delay">#</a> .**delay**(*`seconds:`float*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Delay.mon  "Source")

Delays values and completion by a number of `seconds`.

Note: This will also make every value asynchronous.

```javascript
Observable.fromValues([1,2,3])
	.delay(1.0)
	...

// Output (after 1 second): 1,2,3
```

<a name="async" href="#async">#</a> .**async**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Delay.mon  "Source")

Make every value asynchronous.

```javascript
Observable.fromValues([1,2,3])
	.async()
	...

// Output (Async): 1,2,3
```

<a name="observeon" href="#observeon">#</a> .**observeOn**(*action\<`source:` [IObservable](#iobservable), `dispose:` action\<>> ,  context*) returns [IDisposable](./IDisposable.md#idisposable) [<>](/src/rx/operators/ObserveOn.mon  "Source")<br/>
<a name="observeonnew" href="#observeonnew">#</a> .**observeOnNew**(*action\<`source:` [IObservable](#iobservable), `dispose:` action\<>>*) returns [IDisposable](./IDisposable.md#idisposable) [<>](/src/rx/operators/ObserveOn.mon  "Source")

Continue processing the observable on a different context.

The `dispose` action terminates terminates the cross-context communication. The cross-context communication can be terminated from either side by calling either the provided `dispose` action or by calling the `.dispose()` method of the returned [IDisposable](./IDisposable.md#idisposable). 

**Important Note:** It is important to terminate the cross-context communication to avoid a memory leak.

```javascript
action doOnDifferentContext(IObservable source, action<> dispose) {
	ISubscription s := source
		.map(...)
		.reduce(...)
		.subscribe(...);
	
	s.onUnsubscribe(dispose); // We'll never reconnect so, to avoid a memory leak, we notify the original source of the data that we are done
}

IDisposable d := Observable.fromValues([1,2,3,4])
	.observeOn(doOnDifferentContext, context("Context2"));
```

<a name="tochannel" href="#tochannel">#</a> .**toChannel**(*`channelName:` string*) returns [IDisposable](./IDisposable.md#idisposable) [<>](/src/rx/operators/ToChannel.mon  "Source")

Send every value to a channel. Primitive values are wrapped inside a [WrappedAny](../WrappedAny) so that they can be sent.

The resulting [IDisposable](./IDisposable.md#idisposable) can be used to manually terminate the observable.

Note: Errors are thrown when received, completion causes the observable to terminate.

```javascript
IDisposable d := Observable.fromValue([1,2,3,E(4)])
	.toChannel("OutputChannel")

// Output on "OutputChannel": WrappedAny(1),WrappedAny(2),WrappedAny(3),E(4)
```

<a name="tostream" href="#tostream">#</a> .**toStream**() returns [DisposableStream](../utilities/DisposableStream.md#disposablestream)\<any> [<>](/src/rx/operators/ToStream.mon  "Source")

Output every value into a stream.

The resulting [DisposableStream](../utilities/DisposableStream.md#disposablestream) **should** be used to manually terminate the stream (rather than the normal `.quit()`), the stream will automatically terminate if the source completes.
 
```javascript
DisposableStream d := Observable.fromValues([1,2,3,4])
	.toStream();

stream<any> strm := d.getStream();

d.dispose(); // Use instead of strm.quit();
```

<a name="timestamp" href="#timestamp">#</a> .**timestamp**() returns [IObservable](#iobservable)<[TimestampedValue](../utilities/TimestampedValue.md#timestampedvalue)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/Timestamp.mon  "Source")

Give every value a timestamp as it arrives at the operator.

Note: Uses `currentTime` which, by default, has only 100 millisecond precision.

```javascript
Observable.interval(1.0)
	.timestamp()
	...

// Output: TimestampedValue(0, 1.0), TimestampedValue(1, 2.0), TimestampedValue(2, 3.0)... 
```

<a name="updatetimestamp" href="#updatetimestamp">#</a> .**updateTimestamp**() returns [IObservable](#iobservable)<[TimestampedValue](../utilities/TimestampedValue.md#timestampedvalue)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/Timestamp.mon  "Source")

Update the timestamp on every item as it arrives at the operator.

Un-timestamped values will be timestamped.

Note: Uses `currentTime` which, by default, has only 100 millisecond precision.
```javascript
Observable.interval(1.0)
	.timestamp()
	.delay(1.0)
	.updateTimestamp()
	...

// Output: TimestampedValue(0, 2.0), TimestampedValue(1, 3.0), TimestampedValue(2, 4.0)... 
```

<a name="timeinterval" href="#timeinterval">#</a> .**timeInterval**() returns [IObservable](#iobservable)\<[TimeInterval](../utilities/TimeInterval.md#timeinterval)\<[T](/docs/README.md#wildcard-class-notation)>> [<>](/src/rx/operators/TimeInterval.mon  "Source")

Emit the time between events, as a [TimeInterval](../utilities/TimeInterval.md#timeinterval). Emitting the time between subscription and receiving the value for the first value.

Note: Uses `currentTime` which, by default, has only 100 millisecond precision.

```javascript
Observable.interval(1.0)
	.timeInterval()
	...

// Output: TimeInterval(1.0,0), TimeInterval(1.0,1), TimeInterval(1.0,2)...
```

<a name="pausable" href="#pausable">#</a> .**pausable**(*`trigger:` [IObservable](#iobservable)*) returns [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Pausable.mon  "Source")

Enable and disable receiving values based on the `trigger`. Every time a value is received on the `trigger` observable the gate flips open or closed. The gate **starts closed**, the first value received opens the gate.

Values received while the gate is closed are discarded. To instead buffer them, use [PausableBuffered](#pausablebuffered).

```javascript
Observable.interval(1.0)
	.pausable(Observable.interval(2.0))
	...
// Output: 1, 2, 5, 6, 9
```

<a name="pausablebuffered" href="#pausablebuffered">#</a> .**pausableBuffered**(*`trigger:` [IObservable](#iobservable)*) returns [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/PausableBuffered.mon  "Source")

Enable and disable buffering of values based on the `trigger`. Every time a value is received on the `trigger` observable the gate flips open or closed. Values received while the gate is closed are buffered and emitted as soon as the gate reopens. The gate **starts closed**, the first value received opens the gate.


```javascript
Observable.interval(1.0)
	.pausableBuffered(Observable.interval(2.0))
	...
// Output: 1,2,3,4
```

<a name="let" href="#let">#</a> .**let**(*`operator:` Pipeable*) returns [IObservable](#iobservable)\<any> [<>](/src/rx/operators/Pipe.mon  "Source")

Add a single operator to the observable. Can be used by extension libraries or for custom operators.

Note: Pipeable = `action<action<IObserver> returns ISubscription> returns action<IObserver> returns ISubscription`

```javascript
using com.industry.rx_epl.operators.Sum;

Observable.fromValues([1,2,3,4])
	.let(Sum.create())
	...

// Output: 10
```

<a name="pipe" href="#pipe">#</a> .**pipe**(*`operators:` sequence\<Pipeable>*) returns [IObservable](#iobservable)\<any> [<>](/src/rx/operators/Pipe.mon  "Source")

Add a multiple operators to the observable. Can be used by extension libraries or for custom operators.

Note: Pipeable = `action<action<IObserver> returns ISubscription> returns action<IObserver> returns ISubscription`

```javascript
using com.industry.rx_epl.operators.Map;
using com.industry.rx_epl.operators.Sum;

action multiplyBy10(integer value) returns integer {
	return value * 10;
}

Observable.fromValues([1,2,3,4])
	.pipe([Map.create(multiplyBy10), Sum.create()])
	...

// Output: 100
```
<a name="pipeon" href="#pipeon">#</a> .**pipeOn**(*`operators:` sequence\<Pipeable>, context*) returns [IObservable](#iobservable)\<any> [<>](/src/rx/operators/PipeOn.mon  "Source")<br/>
<a name="pipeonnew" href="#pipeonnew">#</a> .**pipeOnNew**(*`operators:` sequence\<Pipeable>*) returns [IObservable](#iobservable)\<any> [<>](/src/rx/operators/PipeOn.mon  "Source")

Add a multiple operators to the observable and run those operators on a different context. Useful to allow slow operators to run without blocking the main thread. The results are returned to the original context.

Note: Pipeable = `action<action<IObserver> returns ISubscription> returns action<IObserver> returns ISubscription`

```javascript
using com.industry.rx_epl.operators.Map;
using com.industry.rx_epl.operators.Sum;

action multiplyBy10(integer value) returns integer {
	return value * 10;
}

Observable.fromValues([1,2,3,4])
	.pipeOn([Map.create(multiplyBy10), Sum.create()], context("Context2"))
	...

// Output: 100
```

See also: [ObserveOn](#observeon)

<a name="complexpipe" href="#complexpipe">#</a> .**complexPipe**(*`operator:` action<[IObservable](#iobservable)<[T1](/docs/README.md#wildcard-class-notation)>> returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)>*) returns [IObservable](#iobservable)\<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ComplexPipe.mon  "Source")

Add a series of custom operations to the observable.

```javascript

action customOperator(IObservable source) returns IObservable {
	return source.withLatestFromToSequence([source.skipLast(1)]); // Similar to pairwise...
}

Observable.interval(1.0)
	.complexPipe(customOperator)
	...

// Output: [1,0], [2,1], [3,2]
```

<a name="complexpipeon" href="#complexpipeon">#</a> .**complexPipeOn**(*`operator:` action<[IObservable](#iobservable)<[T1](/docs/README.md#wildcard-class-notation)>> returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)>, context*) returns [IObservable](#iobservable)\<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ComplexPipeOn.mon  "Source")<br/>
<a name="complexpipeonnew" href="#complexpipeonnew">#</a> .**complexPipeOnNew**(*`operator:` action<[IObservable](#iobservable)<[T1](/docs/README.md#wildcard-class-notation)>> returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)>*) returns [IObservable](#iobservable)\<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ComplexPipeOn.mon  "Source")

Add a series of custom operations to the observable and run those operations on a different context. Useful to allow slow operators to run without blocking the main thread. The results are returned to the original context.

```javascript

action customOperator(IObservable source) returns IObservable {
	return source.withLatestFromToSequence([source.skipLast(1)]); // Similar to pairwise...
}

Observable.interval(1.0)
	.complexPipeOn(customOperator, context("Context2"))
	...

// Output: [1,0], [2,1], [3,2]
```

<a name="decouple" href="#decouple">#</a> .**decouple**() returns [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/ComplexPipeOn.mon  "Source")

Separate the resulting observable from the source observable.

**Uses:** If the subscription uses [SubscribeOn](#subscribeon) but the source is a shared observable you may need to decouple to get the expected results. (See: [Gotcha](/Readme.md#gotcha-subscribe-on))

**Important Note:** A similar result can be achieved with [ObserveOn](#observeon) and this is advised.

<a name="getsync" href="#getsync">#</a> .**getSync**() returns any [<>](/src/rx/operators/internals/GetSync.mon "Source")

Get the value from a synchronous observable. An empty any will be returned if the observable does not return a value immediately.

Note: If multiple values are received then the last synchronous value will be returned.

```javascript
integer value := <integer> Observable.fromValues([1,2,3,4])
	.sumInteger()
	.getSync();

// value = 10
```

<a name="getsyncor" href="#getsyncor">#</a> .**getSyncOr**(*`default:` any*) returns any [<>](/src/rx/operators/internals/GetSync.mon  "Source")

Get the value from a synchronous observable. The default value will be returned if the observable does not return a value immediately.

Note: If multiple values are received then the last synchronous value will be returned.

```javascript
integer value := <integer> Observable.just(10)
	.getSyncOr(3);
	
// value = 10

integer value2 := <integer> Observable.timer(10, 1.0)
	.getSyncOr(3);
	
// value2 = 3
```

<a name="repeat" href="#repeat">#</a> .**repeat**(*`count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Repeat.mon  "Source")

Repeat an observable, by reconnecting to the source `count-1` times.

```javascript
Observable.fromValues([1,2,3,4])
	.repeat(2)
	...

// Output: 1,2,3,4,1,2,3,4
```

<a name="publish" href="#publish">#</a> .**publish**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/internals/PublishReplay.mon  "Source")

Publish allows a single observable subscription to be shared among various other subscribers. Delaying upstream subscription until [.connect()](#connect) is called.

This is explained further in the [User Guide](/Readme.md#multicasting).

```javascript
IObservable o := Observable.interval(1.0).publish();

ISubscription s := o.subscribe(Subscriber.create().onNext(printValue));
// Output (When connect is called): 0, 1, 2, 3...

on wait(2.0) {
    ISubscription s2 := o.subscribe(Subscriber.create().onNext(printValue));
    // Output (When connect is called): 0, 1, 2, 3...

    IDisposable d := o.connect();
}
```

<a name="connect" href="#connect">#</a> .**connect**() returns [IDisposable](./IDisposable.md#idisposable) [<>](/src/rx/operators/internals/Publish.mon  "Source")

Connect to a [published](#publish) observable, causing it to start emitting values.

The returned [IDisposable](./IDisposable.md#idisposable) can be used to disconnect, terminating the connected observables (without completion).

See also: [RefCount](#refcount)

<a name="publishreplay" href="#publishreplay">#</a> .**publishReplay**(*`count:` integer*) returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/internals/PublishReplay.mon  "Source")

Similar to [Publish](#publish), except it stores up to `count` values received after [.connect()](#connect) is called, replaying the latest to any late subscriptions.

Note: Values are replayed to new subscriptions even if the source completes. To empty the replay cache dispose of the [IDisposable](./IDisposable.md#idisposable) returned from  [.connect()](#connect).

```javascript
IObservable o := Observable.interval(1.0).publishReplay(2);

ISubscription s := o.subscribe(Subscriber.create().onNext(printValue));
// Output (When connect is called): 0, 1, 2, 3...
IDisposable d := o.connect();

on wait(2.0) {
    ISubscription s2 := o.subscribe(Subscriber.create().onNext(printValue));
    // Output: 0, 1, 2, 3...
    // Would have missed 0,1 if .publish() had been used
}
```

<a name="refcount" href="#refcount">#</a> .**refCount**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/internals/RefCount.mon  "Source")

Automatically [.connect()](#connect) and disconnect from the upstream observable after the first subscription and last unsubscription.

```javascript
IObservable o := Observable.interval(1.0).publish().refCount(); // can be replaced with .share()

ISubscription s := o.subscribe(Subscriber.create().onNext(printValue));
// Output: 0, 1, 2, 3...

on wait(2.0) {
    ISubscription s2 := o.subscribe(Subscriber.create().onNext(printValue));
    // Output: 2, 3...
}
```

<a name="share" href="#share">#</a> .**share**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/internals/Share.mon  "Source")

Shorthand for [.publish()](#publish)[.refCount()](#refcount)

<a name="sharereplay" href="#sharereplay">#</a> .**shareReplay**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/internals/ShareReplay.mon  "Source")

Shorthand for [.publishReplay()](#publishreplay)[.refCount()](#refcount)

<a name="observetochannel" href="#observetochannel">#</a> .**observeToChannel**(`channel:` string) returns [IDisposable](./IDisposable.md#idisposable) [<>](/src/rx/operators/internals/ObserveTo.mon  "Source")

ObserveToChannel and [ObserveFromChannel](../constructors/Observable#observefromchannel) are useful for sending data between different monitor instances which may or may not be on different contexts.

Note: `.dispose()` should be called on the returned [IDisposable](./IDisposable.md#idisposable) when all subscribers are finished to avoid a memory leak.

```javascript
// Ideally should dispose of this when all subscribers are finished (if ever)
IDisposable d := Observable.interval(1.0).observeToChannel("channelName");

// This could be in a different monitor
ISubscription s := Observable.observeFromChannel("channelName")
        .subscribe(Subscriber.create().onNext(printValue));
        
// Output: 0, 1, 2, 3
```

<a name="ignoreelements" href="#ignoreelements">#</a> .**ignoreElements**() returns [IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/IgnoreElements.mon  "Source")

Ignore all of the values from the source but pass on termination events (Error or Completion).

```javascript
Observable.interval(1.0).take(5)
	.ignoreElements()
	.subscribe(Subscriber.create().onNext(logValue).onComplete(logComplete))
	
// Output (5 seconds later): Complete!
```

### Conditional

<a name="contains" href="#contains">#</a> .**contains**(*`predicate:` action<`value:` [T](/docs/README.md#wildcard-class-notation)> returns boolean*) returns [IObservable](#iobservable)\<boolean> [<>](/src/rx/operators/Contains.mon  "Source")

Check if at least one `value` matches the `predicate`.

Note: An empty observable returns `false`.

```javascript
action greaterThan3(integer value) returns boolean {
	return value > 3;
}

Observable.fromValues([1,2,3,4])
	.contains(greaterThan3)
	...

// Output: true
```

<a name="every" href="#every">#</a> .**every**(*`predicate:` action<`value:` [T](/docs/README.md#wildcard-class-notation)> returns boolean*) returns [IObservable](#iobservable)\<boolean> [<>](/src/rx/operators/Every.mon  "Source")

Check if every `value` matches the `predicate`.

Note: An empty observable returns `true`.

```javascript
action lessThan3(integer value) returns boolean {
	return value < 3;
}

Observable.fromValues([1,2,3,4])
	.every(lessThan3)
	...

// Output: false
```

<a name="sequenceequal" href="#sequenceequal">#</a> .**sequenceEqual**(*`others:` sequence<[IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)>>*) returns [IObservable](#iobservable)\<boolean> [<>](/src/rx/operators/Every.mon  "Source")

Check if all of the provided observables contain the same values, in the same order.

```javascript
Observable.interval(1.0).take(4)
	.sequenceEqual([Observable.fromValues([0,1,2,3]), Observable.range(0,3)])
	...

// Output: true
```

<a name="isempty" href="#isempty">#</a> .**isEmpty**() returns [IObservable](#iobservable)\<boolean> [<>](/src/rx/operators/IsEmpty.mon  "Source")

Check if the observable completes without emitting any values.

Note: It will return false immediately if any values are received.

```javascript
Observable.fromValues([1,2,3])
	.isEmpty()
	...

// Output: false

Observable.empty()
	.isEmpty()
	...

// Output: true
```

<a name="amb" href="#amb">#</a> .**amb**(*`others:` sequence<[IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)>>*) returns [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Amb.mon  "Source")<br/>
<a name="race" href="#race">#</a> .**race**(*`others:` sequence<[IObservable](#iobservable)<[T](/docs/README.md#wildcard-class-notation)>>*) returns [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Amb.mon  "Source")

Race the observables, the one which provides values first provides all of the values.

Note: Amb and Race are aliases.

```javascript
Observable.timer("I lost", 5.0)
	.amb([Observable.timer("I won!", 1.0)])
	...

// Output: "I won!"
```

<a name="defaultifempty" href="#defaultifempty">#</a> .**defaultIfEmpty**(*`value:` [T](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/DefaultIfEmpty.mon  "Source")

Emit a default value if the source completes without emitting any values.

```javascript
Observable.empty()
	.defaultIfEmpty("A default value")
	...

// Output: "A default value"
```

<a name="switchifempty" href="#switchifempty">#</a> .**switchIfEmpty**(*`alternative:` [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)>*) returns [IObservable](#iobservable)\<[T](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/SwitchIfEmpty.mon  "Source")

Switch to a different observable source if the main source completes without emitting any values.

```javascript
Observable.empty()
	.switchIfEmpty(Observable.fromValues([1,2,3]))
	...

// Output: 1,2,3
```

### Math and Aggregation

<a name="reduce" href="#reduce">#</a> .**reduce**(*action<`aggregate:` [T2](/docs/README.md#wildcard-class-notation), `value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Scan.mon  "Source")

Aggregate the data, emitting the aggregated value on completion.

Note: The first value is used as the starting value for the aggregation.

```javascript
action sum(integer currentSum, integer value) returns integer {
	return currentSum + value;
}

Observable.fromValues([1,2,3])
	.reduce(sum)
	...

// Output: 6
```
See also: [Scan](#scan)

<a name="reducewithinitial" href="#reducewithinitial">#</a> .**reduceWithInitial**(*action<`aggregate:` [T2](/docs/README.md#wildcard-class-notation), `value:` [T1](/docs/README.md#wildcard-class-notation)> returns [T2](/docs/README.md#wildcard-class-notation), `initialValue:` [T2](/docs/README.md#wildcard-class-notation)*) returns [IObservable](#iobservable)<[T2](/docs/README.md#wildcard-class-notation)> [<>](/src/rx/operators/Scan.mon  "Source")

Aggregate the data, emitting the aggregated value on completion.. The initial value for the aggregation is supplied.
```javascript
action sum(integer currentSum, integer value) returns integer {
	return currentSum + value;
}

Observable.fromValues([1,2,3])
	.reduceWithInitial(sum, 5)
	...

// Output: 11
```
See also: [ScanWithInitial](#scanwithinitial)

<a name="count" href="#count">#</a> .**count**() returns [IObservable](#iobservable)\<integer> [<>](/src/rx/operators/Aggregates.mon  "Source")

Count the number of items emitted by the source.

Note: This is final count, not a rolling count.

```javascript
Observable.fromValues([1,2,3,4])
	.count()
	...

// Output: 4
```

<a name="sum" href="#sum">#</a> .**sum**() returns [IObservable](#iobservable)\<float> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="suminteger" href="#suminteger">#</a> .**sumInteger**() returns [IObservable](#iobservable)\<integer> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="sumfloat" href="#sumfloat">#</a> .**sumFloat**() returns [IObservable](#iobservable)\<float> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="sumdecimal" href="#sumdecimal">#</a> .**sumDecimal**() returns [IObservable](#iobservable)\<decimal> [<>](/src/rx/operators/Aggregates.mon  "Source")

Sum the provided values.

Note: `.sum()` will work for any numeric type (returning a float), whereas `.sumInteger()`, `.sumFloat()`, `.sumDecimal()` will only operate on their respective types.

```javascript
Observable.fromValues([1,2,3,4])
	.sum()
	...

// Output: 10.0
```

<a name="concatstring" href="#concatstring">#</a> .**concatString**() returns [IObservable](#iobservable)\<string> [<>](/src/rx/operators/Aggregates.mon  "Source")

Concatenate the `.valueToString()` of every value.

```javascript
Observable.fromValues([<any> "Hello ", "World", "! ", 1, 2, 3])
	.concatString()
	...

// Output: "Hello World! 123"
```

<a name="max" href="#max">#</a> .**max**() returns [IObservable](#iobservable)\<float> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="maxinteger" href="#maxinteger">#</a> .**maxInteger**() returns [IObservable](#iobservable)\<integer> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="maxfloat" href="#maxfloat">#</a> .**maxFloat**() returns [IObservable](#iobservable)\<float> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="maxdecimal" href="#maxdecimal">#</a> .**maxDecimal**() returns [IObservable](#iobservable)\<decimal> [<>](/src/rx/operators/Aggregates.mon  "Source")

Find the largest value.

Note: `.max()` will work for any numeric type (returning a float), whereas `.maxInteger()`, `.maxFloat()`, `.maxDecimal()` will only operate on their respective types.

```javascript
Observable.fromValues([1,2,3,4])
	.max()
	...

// Output: 4.0
```

<a name="min" href="#min">#</a> .**min**() returns [IObservable](#iobservable)\<float> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="mininteger" href="#mininteger">#</a> .**minInteger**() returns [IObservable](#iobservable)\<integer> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="minfloat" href="#minfloat">#</a> .**minFloat**() returns [IObservable](#iobservable)\<float> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="mindecimal" href="#mindecimal">#</a> .**minDecimal**() returns [IObservable](#iobservable)\<decimal> [<>](/src/rx/operators/Aggregates.mon  "Source")

Find the smallest value.

Note: `.min()` will work for any numeric type (returning a float), whereas `.minInteger()`, `.minFloat()`, `.minDecimal()` will only operate on their respective types.

```javascript
Observable.fromValues([1,2,3,4])
	.min()
	...

// Output: 1.0
```

<a name="average" href="#average">#</a> .**average**() returns [IObservable](#iobservable)\<float> [<>](/src/rx/operators/Aggregates.mon  "Source")<br/>
<a name="averagedecimal" href="#averagedecimal">#</a> .**averageDecimal**() returns [IObservable](#iobservable)\<decimal> [<>](/src/rx/operators/Aggregates.mon  "Source")

Find the arithmetic mean.

Note: Both `.average()` and `.averageDecimal()` will operate on numbers of any type, they differ on output type only.

```javascript
Observable.fromValues([1,2,3,4])
	.average()
	...

// Output: 2.5
```
