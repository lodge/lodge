class Editor extends React.Component {
  static propTypes = {
    markdown: React.PropTypes.string,
    id: React.PropTypes.string.isRequired,
    nameAttr: React.PropTypes.string.isRequired
  }

  state = {
    markdown: this.props.markdown || ''
  }
  updateMarkdown = (markdown) => {
    this.setState({ markdown: markdown });
  }

  render() {
    let markdown = this.state.markdown;
    return (
      <div className="markdown-editor row">
        <EditorMarkdown
          id={ this.props.id }
          nameAttr={ this.props.nameAttr }
          onChange={ this.updateMarkdown }>
          { markdown }
        </EditorMarkdown>
        <EditorPreview markdown={ markdown } />
      </div>
    );
  }
}

class EditorMarkdown extends React.Component {
  static propTypes = {
    id: React.PropTypes.string.isRequired,
    nameAttr: React.PropTypes.string.isRequired,
    onChange: React.PropTypes.func.isRequired
  }

  _onChange = (e) => {
    this.props.onChange(e.target.value);
  }

  render() {
    return (
      <div className="col-xs-6">
        <textarea
          id={ this.props.id }
          className="editor-textarea form-control"
          name={ this.props.nameAttr }
          value={ this.props.children }
          onChange={ this._onChange } />
      </div>
    );
  }
}

class EditorPreview extends React.Component {
  static propTypes = {
    markdown: React.PropTypes.string.isRequired
  }

  rawMarkup() {
    return { __html: marked(this.props.markdown) };
  }

  render() {
    return (
      <div
        className="markdown codehilite col-xs-6"
        dangerouslySetInnerHTML={ this.rawMarkup() } />
    );
  }
}
