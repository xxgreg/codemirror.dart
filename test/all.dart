// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library codemirror.tests;

import 'dart:html';

import 'package:codemirror/codemirror.dart';
import 'package:unittest/html_config.dart';
import 'package:unittest/unittest.dart';

// TODO: get the tests running in content_shell

// TODO: test double click

// TODO: document mutation

final Element editorHost = new DivElement();

void main() {
  useHtmlConfiguration();

  document.body.children.add(editorHost);

  group('simple', createSimpleTests);
  group('CodeMirror', createCodeMirrorTests);
  group('CodeMirror (static) ', createCodeMirrorStaticTests);
  group('Doc', createDocTests);
  group('history', createHistoryTests);
}

createSimpleTests() {
  test('create', () {
    CodeMirror editor = new CodeMirror.fromElement(editorHost);
    expect(editor, isNotNull);
    expect(editorHost.parent, isNotNull);
    editor.dispose();
    editorHost.children.clear();
  });
}

createCodeMirrorStaticTests() {
  test('modes', () {
    expect(CodeMirror.MODES.length, greaterThanOrEqualTo(10));
  });

  test('mime modes', () {
    expect(CodeMirror.MIME_MODES.length, greaterThanOrEqualTo(10));
  });

  test('commands', () {
    expect(CodeMirror.COMMANDS.length, greaterThanOrEqualTo(10));
  });

  test('key map', () {
    expect(CodeMirror.KEY_MAPS.length, 4);
  });

  test('themes', () {
    expect(CodeMirror.THEMES.length, greaterThanOrEqualTo(10));
  });

  test('version', () {
    expect(CodeMirror.version.length, greaterThanOrEqualTo(3));
  });
}

createCodeMirrorTests() {
  CodeMirror editor;

  setUp(() {
    editor = new CodeMirror.fromElement(editorHost);
  });

  tearDown(() {
    editor.dispose();
    editorHost.children.clear();
  });

  test('simple', () {
    expect(editor, isNotNull);
    expect(editorHost.parent, isNotNull);
  });

  test('getOption / setOption', () {
    expect(editor.getOption('lineWrapping'), false);
    editor.setOption('lineWrapping', true);
    expect(editor.getOption('lineWrapping'), true);
  });

  test('getLine', () {
    Doc doc = editor.getDoc();
    doc.setValue('one\ntwo\nthree');
    expect(editor.getLine(0), 'one');
    expect(editor.getLine(1), 'two');
    expect(editor.getLine(2), 'three');
  });
}

createDocTests() {
  CodeMirror editor;

  setUp(() {
    editor = new CodeMirror.fromElement(editorHost);
  });

  tearDown(() {
    editor.dispose();
    editorHost.children.clear();
  });

  test('getValue / getValue', () {
    Doc doc = editor.getDoc();
    expect(doc.getValue(), '');
    doc.setValue('foo bar');
    expect(doc.getValue(), 'foo bar');
  });

  test('getLine', () {
    Doc doc = editor.getDoc();
    doc.setValue('one\ntwo\nthree');
    expect(doc.getLine(0), 'one');
    expect(doc.getLine(1), 'two');
    expect(doc.getLine(2), 'three');
  });
}

createHistoryTests() {
  CodeMirror editor;

  setUp(() {
    editor = new CodeMirror.fromElement(editorHost);
  });

  tearDown(() {
    editor.dispose();
    editorHost.children.clear();
  });

  test('undo / redo', () {
    Doc doc = editor.getDoc();
    _expectHistory(doc, 0, 0);
    doc.replaceRange('foo', doc.getCursor());
    _expectHistory(doc, 1, 0);
    doc.undo();
    _expectHistory(doc, 0, 1);
    doc.redo();
    _expectHistory(doc, 1, 0);
  });

  test('clearHistory', () {
    Doc doc = editor.getDoc();
    doc.replaceRange('foo', doc.getCursor());
    _expectHistory(doc, 1, 0);
    doc.clearHistory();
    _expectHistory(doc, 0, 0);
  });

  test('getHistory', () {
    Doc doc = editor.getDoc();
    doc.setValue('one\ntwo\nthree');
    expect(doc.getHistory(), isNotNull);
  });
}

void _expectHistory(Doc doc, int undo, int redo) {
  Map m = doc.historySize();
  expect(m['undo'], undo);
  expect(m['redo'], redo);
}
