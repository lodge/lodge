class Editor extends React.Component {
  static propTypes = {
    defaultValue: React.PropTypes.string,
    objectName: React.PropTypes.string.isRequired,
    fieldName: React.PropTypes.string.isRequired
  }

  state = {
    value: this.props.defaultValue || ''
  }
  handleTextChange = (e) => {
    this.setState({ value: e.target.value });
  }

  render() {
    let {value} = this.state;
    return (
      <div className="markdown-editor row">
        <EditorMarkdown { ...this.props }
          onChange={ this.handleTextChange }
          value={ value } />
        <EditorPreview value={ value } />
      </div>
    );
  }
}

const EditorMarkdown = ({
  value,
  onChange,
  objectName,
  fieldName
}) => (
  <div className="col-xs-6">
    <textarea
      id={ `${objectName}_${fieldName}` }
      className="editor-textarea form-control"
      name={ `${objectName}[${fieldName}]` }
      value={ value }
      onChange={ onChange } />
  </div>
);

const EditorPreview = ({
  value
}) => (
  <div className="markdown codehilite col-xs-6"
    dangerouslySetInnerHTML={
      { __html: marked(value) }
    } />
);
