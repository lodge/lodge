class Editor extends React.Component {
  static propTypes = {
    defaultValue: React.PropTypes.string,
    objectName: React.PropTypes.string.isRequired,
    fieldName: React.PropTypes.string.isRequired,
    url: React.PropTypes.string.isRequired
  }
  state = { html: '' }
  componentDidMount() {
    this.preview(this.props.defaultValue);
  }

  handleChange = (e) => {
    this.preview(e.target.value);
  }
  compile = (rawMarkdown) => {
    let token = document.querySelector('meta[name=csrf-token]').content;

    return request.post(this.props.url, {
      body: rawMarkdown,
      authenticity_token: token
    }, {
      headers: {
        'Accept': 'text/javascript'
      }
    });
  }
  preview = (rawMarkdown) => {
    this.compile(rawMarkdown).then((response) => {
      this.setState({ html: response.data });
    })
    .catch((response) => {
      console.log(response);
      this.setState({ html: rawMarkdown });
    });
  }

  render() {
    let { html } = this.state;
    return (
      <div className="markdown-editor row">
        <EditorMarkdown { ...this.props }
          onChange={ this.handleChange } />
        <EditorPreview html={ html } />
      </div>
    );
  }
}

const EditorMarkdown = ({
  onChange,
  objectName,
  fieldName,
  defaultValue
}) => (
  <div className="col-xs-6">
    <textarea
      id={ `${objectName}_${fieldName}` }
      className="editor-textarea form-control"
      name={ `${objectName}[${fieldName}]` }
      defaultValue={ defaultValue }
      onChange={ onChange } />
  </div>
);

const EditorPreview = ({
  html
}) => (
  <div className="markdown codehilite col-xs-6"
    dangerouslySetInnerHTML={
      { __html: html }
    } />
);
