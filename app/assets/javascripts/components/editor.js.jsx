class Editor extends React.Component {
  state = {
    markdown: ''
  }
  updateMarkdown = (markdown) => {
    this.setState({ markdown: markdown });
  }

  render() {
    return (
      <div>
        <EditorMarkdown onChange={ this.updateMarkdown } />
        <EditorPreview markdown={ this.state.markdown } />
      </div>
    );
  }
}

class EditorMarkdown extends React.Component {
  static propTypes = {
    onChange: React.PropTypes.func.isRequired
  }

  _onChange = (e) => {
    this.props.onChange(e.target.value);
  }

  render() {
    return (
      <textarea onChange={ this._onChange } />
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
      <div dangerouslySetInnerHTML={ this.rawMarkup() } />
    );
  }
}
