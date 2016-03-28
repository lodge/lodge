const AUTO_PREVIEW_INTERVAL = 1000;

class Editor extends React.Component {
  static propTypes = {
    className: React.PropTypes.string.isRequired,
    defaultValue: React.PropTypes.string,
    objectName: React.PropTypes.string.isRequired,
    fieldName: React.PropTypes.string.isRequired,
    url: React.PropTypes.string.isRequired
  }
  constructor(props) {
    super(props);

    this.state = {
      html: '',
      height: 0
    }
    this.preview = throttle(this.preview, AUTO_PREVIEW_INTERVAL, {
      leading: false
    });
  }
  componentDidMount() {
    const className = `.${this.props.className}__textarea`;
    const height = document.querySelector(className).offsetHeight;
    this.setState({ height });

    this.preview(this.props.defaultValue);
  }

  handleChange = (e) => {
    this.preview(e.target.value);
  }
  handleMouseUp = (e) => {
    const height = e.target.offsetHeight;
    this.setState({ height });
  }
  compile = (rawMarkdown) => {
    const token = document.querySelector('meta[name=csrf-token]').content;

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
    const { html, height } = this.state;
    const { className } = this.props;

    return (
      <div className={ `${className} row` }>
        <EditorMarkdown { ...this.props }
          onChange={ this.handleChange }
          onMouseUp={ this.handleMouseUp } />
        <EditorPreview className={ className }
          html={ html }
          height={ height } />
      </div>
    );
  }
}

const EditorMarkdown = ({
  onChange,
  onMouseUp,
  className,
  objectName,
  fieldName,
  defaultValue
}) => (
  <div className="col-xs-6">
    <textarea
      id={ `${objectName}_${fieldName}` }
      className={ `${className}__textarea editor-textarea form-control` }
      name={ `${objectName}[${fieldName}]` }
      defaultValue={ defaultValue }
      onChange={ onChange }
      onMouseUp={ onMouseUp } />
  </div>
);

const EditorPreview = ({
  className,
  html,
  height
}) => (
  <div className={ `${className}__previewarea markdown codehilite col-xs-6` }
    style={ { height } }
    dangerouslySetInnerHTML={
      { __html: html }
    } />
);
