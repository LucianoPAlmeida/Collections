# Collections

[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.com/LucianoPAlmeida/Collections.svg?branch=master)](https://travis-ci.com/LucianoPAlmeida/Collections)

Playing around with Swift Collections and Sequences implementations.
This is just a personal repo for testing and implement cool thing involving collection and sequences in Swift.

## Contents
* [ChunkedCollection](Collections/ChunkedCollection.swift) - A collection that presents the elements of its base collection in `SubSequence` chunks of any given size. Pedding evolution proposal review [here](https://github.com/apple/swift-evolution/pull/935)
* [RotatedCollection](Collections/RotatedCollection.swift) - A collection that presents the elements of its base collection with the elements position rotated by a given offset.
* [InterspersedSequence](Collections/Sequence/InterspersedSequence.swift) - A lazy view for sequence that creates a new sequece where for each iteration of the base sequence the value is inserted.

## Licence

Collections is released under MIT Licence.
